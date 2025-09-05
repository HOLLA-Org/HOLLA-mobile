import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/bloc/location/location_bloc.dart';
import 'package:holla/bloc/location/location_event.dart';
import 'package:holla/bloc/location/location_state.dart';
import 'package:holla/routes/app_routes.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  final bool _isMapLoading = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(21.028511, 105.854164), // Hanoi, Vietnam
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(LocationGetCurrent());
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: const InfoWindow(title: 'Vị trí đã chọn'),
        ),
      );
    });
  }

  void _handleSelectPosition() {
    if (_markers.isNotEmpty) {
      context.read<LocationBloc>().add(
        LocationMarkerConfirmed(_markers.first.position),
      );
      if (!mounted) return;
      context.go(AppRoutes.loading);
    }
  }

  void _onSelectedPlaceChanged(LocationState state) async {
    if (state.selectedPlace != null) {
      final LatLng newPosition = LatLng(
        state.selectedPlace!.lat,
        state.selectedPlace!.lng,
      );
      final GoogleMapController controller = await _mapController.future;

      if (!mounted) return;

      controller.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 16.0));
      _updateMarker(newPosition);

      _searchController.clear();
      context.read<LocationBloc>().add(LocationSearchChanged(""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn vị trí'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _handleSelectPosition(),
          ),
        ],
      ),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) => _onSelectedPlaceChanged(state),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              markers: _markers,
              onTap: _updateMarker,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
            ),

            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm địa điểm...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon:
                                state.loading
                                    ? const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                    : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            context.read<LocationBloc>().add(
                              LocationSearchChanged(value),
                            );
                          },
                        ),
                        if (state.predictions.isNotEmpty) ...[
                          const Divider(height: 1),
                          LimitedBox(
                            maxHeight: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.predictions.length,
                              itemBuilder: (context, index) {
                                final prediction = state.predictions[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                  ),
                                  title: Text(prediction.description),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    context.read<LocationBloc>().add(
                                      LocationPredictionSelected(
                                        prediction.placeId,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            if (_isMapLoading)
              Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
