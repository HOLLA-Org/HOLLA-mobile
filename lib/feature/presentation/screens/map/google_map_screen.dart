import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/feature/presentation/bloc/location/location_bloc.dart';
import 'package:holla/feature/presentation/bloc/location/location_event.dart';
import 'package:holla/feature/presentation/bloc/location/location_state.dart';
import 'package:holla/config/routes/app_routes.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  bool _isMapLoading = true;
  Timer? _debounce;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(21.028511, 105.854164), // Hanoi, Vietnam
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(const LocationGetCurrent());
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
      return;
    }

    final current = context.read<LocationBloc>().state.currentLocation;
    if (current != null) {
      context.read<LocationBloc>().add(LocationMarkerConfirmed(current));
      if (!mounted) return;
      context.go(AppRoutes.loading);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa xác định được vị trí hiện tại')),
      );
    }
  }

  void _onSelectedPlaceChanged(LocationState state) async {
    final controller = await _mapController.future;
    if (!mounted) return;

    if (state.selectedPlace != null) {
      final pos = state.selectedPlace!;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await controller.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
          _updateMarker(pos);
        } catch (e) {
          debugPrint("Error animating camera: $e");
        }
      });

      return;
    }

    if (state.currentLocation != null) {
      final pos = state.currentLocation!;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await controller.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
        } catch (e) {
          debugPrint("Error animating to current location: $e");
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<LocationBloc>().add(LocationSearchChanged(query));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
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
        listenWhen:
            (prev, curr) =>
                prev.selectedPlace != curr.selectedPlace ||
                prev.currentLocation != curr.currentLocation,
        listener: (context, state) => _onSelectedPlaceChanged(state),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
                if (mounted) {
                  setState(() {
                    _isMapLoading = false;
                  });
                }
              },
              markers: _markers,
              onTap: _updateMarker,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
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
                          onChanged: _onSearchChanged,
                          onSubmitted: (value) {
                            if (state.predictions.isEmpty) return;

                            final prediction = state.predictions.firstWhere(
                              (p) => p.description.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                              orElse: () => state.predictions.first,
                            );

                            context.read<LocationBloc>().add(
                              LocationPredictionSelected(prediction),
                            );

                            _searchController.clear();
                            context.read<LocationBloc>().add(
                              const LocationSearchChanged(""),
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
                                      LocationPredictionSelected(prediction),
                                    );
                                    _searchController.clear();
                                    context.read<LocationBloc>().add(
                                      const LocationSearchChanged(""),
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
