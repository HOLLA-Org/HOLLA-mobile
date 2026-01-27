import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/presentation/bloc/location/location_bloc.dart';
import 'package:holla/presentation/bloc/location/location_event.dart';
import 'package:holla/presentation/bloc/location/location_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:holla/core/config/themes/app_colors.dart';
import 'package:holla/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_event.dart';
import 'package:holla/presentation/bloc/setting/setting_state.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  static const double _hanoiLat = 21.0278;
  static const double _hanoiLng = 105.8342;

  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  Uint8List? _markerIcon;
  final TextEditingController _searchController = TextEditingController();
  bool _showSuggestions = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(LocationGetCurrent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Load marker icon
  Future<void> _ensureMarkerIconLoaded() async {
    if (_markerIcon != null) return;
    final data = await rootBundle.load('assets/icons/map/marker.png');
    _markerIcon = data.buffer.asUint8List();
  }

  /// Handle map created
  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    await _ensureMarkerIconLoaded();

    if (!mounted) return;

    final state = context.read<LocationBloc>().state;
    double lat = state.currentLat ?? _hanoiLat;
    double lng = state.currentLng ?? _hanoiLng;

    _moveCamera(lat, lng);
    _updateMarker(lat, lng);
    context.read<LocationBloc>().add(LocationMarkerMoved(lat, lng));
  }

  /// Handle search changed
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        setState(() => _showSuggestions = false);
      } else {
        setState(() => _showSuggestions = true);
        context.read<LocationBloc>().add(LocationSearchChanged(value));
      }
    });
  }

  /// Handle select prediction
  void _onSelectPrediction(String placeId, String description) {
    FocusScope.of(context).unfocus();
    setState(() {
      _showSuggestions = false;
      _searchController.text = description;
    });
    context.read<LocationBloc>().add(LocationPredictionSelected(placeId));
  }

  /// Go to my location
  Future<void> _goToMyLocation() async {
    final state = context.read<LocationBloc>().state;
    if (state.currentLat != null && state.currentLng != null) {
      _moveCamera(state.currentLat!, state.currentLng!);
      _updateMarker(state.currentLat!, state.currentLng!);
      context.read<LocationBloc>().add(
        LocationMarkerMoved(state.currentLat!, state.currentLng!),
      );
    } else {
      _moveCamera(_hanoiLat, _hanoiLng);
      _updateMarker(_hanoiLat, _hanoiLng);
      context.read<LocationBloc>().add(LocationGetCurrent());
    }
  }

  /// Move camera to specific location
  void _moveCamera(double lat, double lng) {
    _mapboxMap?.flyTo(
      CameraOptions(center: Point(coordinates: Position(lng, lat)), zoom: 15.0),
      MapAnimationOptions(duration: 800),
    );
  }

  /// Update marker position
  Future<void> _updateMarker(double lat, double lng) async {
    if (_pointAnnotationManager == null) return;
    await _ensureMarkerIconLoaded();

    await _pointAnnotationManager!.deleteAll();
    await _pointAnnotationManager!.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(lng, lat)),
        iconSize: 1.5,
        image: _markerIcon,
      ),
    );
  }

  /// Handle save location
  void _handleSave() {
    final state = context.read<LocationBloc>().state;
    double? lat;
    double? lng;
    String? address;
    String? locationName;

    if (state.confirmedLat != null && state.confirmedLng != null) {
      lat = state.confirmedLat;
      lng = state.confirmedLng;
      address = state.confirmedAddress ?? "Vị trí đã chọn";
      locationName = state.confirmedAddress ?? "Vị trí đã chọn";
    } else if (state.selectedPlace != null) {
      lat = state.selectedPlace!.lat;
      lng = state.selectedPlace!.lng;
      address = state.selectedPlace!.name;
      locationName = state.selectedPlace!.name;
    } else if (state.currentLat != null) {
      lat = state.currentLat;
      lng = state.currentLng;
      address = "Vị trí hiện tại";
      locationName = "Vị trí hiện tại";
    }

    if (lat != null && lng != null) {
      context.read<LocationBloc>().add(
        LocationMarkerConfirmed(
          lat: lat,
          lng: lng,
          address: address ?? "Vị trí đã chọn",
        ),
      );

      context.read<SettingBloc>().add(
        UpdateProfileSubmitted(
          latitude: lat,
          longitude: lng,
          address: address,
          locationName: locationName,
        ),
      );
    }
  }

  /// Zoom in
  Future<void> _zoomIn() async {
    if (_mapboxMap == null) return;
    final camera = await _mapboxMap!.getCameraState();
    _mapboxMap?.easeTo(
      CameraOptions(zoom: camera.zoom + 1),
      MapAnimationOptions(duration: 300),
    );
  }

  /// Zoom out
  Future<void> _zoomOut() async {
    if (_mapboxMap == null) return;
    final camera = await _mapboxMap!.getCameraState();
    _mapboxMap?.easeTo(
      CameraOptions(zoom: camera.zoom - 1),
      MapAnimationOptions(duration: 300),
    );
  }

  /// Handle back button
  void _handleBack() {
    context.go(AppRoutes.locationpermission);
  }

  /// Clear search input and hide suggestions
  void _handleClearSearch() {
    _searchController.clear();
    setState(() {
      _showSuggestions = false;
    });
  }

  /// Handle map tap to move marker
  void _onMapTap(dynamic gestureContext) {
    final lat = gestureContext.point.coordinates.lat.toDouble();
    final lng = gestureContext.point.coordinates.lng.toDouble();
    _updateMarker(lat, lng);
    context.read<LocationBloc>().add(LocationMarkerMoved(lat, lng));
  }

  /// Handle changes in location state
  void _handleLocationStateChange(LocationState state) {
    if (state.selectedPlace != null) {
      _moveCamera(state.selectedPlace!.lat, state.selectedPlace!.lng);
      _updateMarker(state.selectedPlace!.lat, state.selectedPlace!.lng);
      context.read<LocationBloc>().add(
        LocationMarkerMoved(state.selectedPlace!.lat, state.selectedPlace!.lng),
      );
    }
    if (state.currentLat != null &&
        state.confirmedLat == null &&
        state.selectedPlace == null) {
      _moveCamera(state.currentLat!, state.currentLng!);
      _updateMarker(state.currentLat!, state.currentLng!);
      context.read<LocationBloc>().add(
        LocationMarkerMoved(state.currentLat!, state.currentLng!),
      );
    }
  }

  /// Handle changes in setting state
  void _handleSettingStateChange(SettingState state) {
    if (state is UpdateProfileSuccess) {
      context.go(AppRoutes.loading);
    } else if (state is UpdateProfileFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) => _handleLocationStateChange(state),
          ),
          BlocListener<SettingBloc, SettingState>(
            listener: (context, state) => _handleSettingStateChange(state),
          ),
        ],
        child: Stack(
          children: [
            /// Map box
            MapWidget(
              key: const ValueKey('mapbox'),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(_hanoiLng, _hanoiLat)),
                zoom: 16,
              ),
              onMapCreated: _onMapCreated,
              onTapListener: _onMapTap,
            ),

            /// Back button
            Positioned(
              top: 30.h,
              left: 4.w,
              child: InkWell(
                onTap: () => _handleBack(),
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.chevronLeft,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'common.back'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Search bar
            Positioned(
              top: 65.h,
              left: 16.w,
              right: 16.w,
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  return Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16.r),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'location_selection.search_hint'.tr(),
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.disableTypo,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: AppColors.disableTypo,
                          size: 24.sp,
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? InkWell(
                                  onTap: _handleClearSearch,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: Icon(
                                      LucideIcons.xCircle,
                                      color: AppColors.error,
                                      size: 20.sp,
                                    ),
                                  ),
                                )
                                : (state.loading
                                    ? UnconstrainedBox(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                    : null),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Search results list
            Positioned(
              top: 115.h,
              left: 16.w,
              right: 16.w,
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (!_showSuggestions || state.predictions.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12.r),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: state.predictions.length,
                      separatorBuilder: (_, __) => Divider(height: 1.h),
                      itemBuilder: (context, index) {
                        final item = state.predictions[index];

                        return ListTile(
                          title: Text(
                            item.description,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          onTap:
                              () => _onSelectPrediction(
                                item.placeId,
                                item.description,
                              ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            /// My location & Zoom buttons
            Positioned(
              bottom: 100.h,
              right: 16.w,
              child: Column(
                children: [
                  // My location button
                  InkWell(
                    onTap: _goToMyLocation,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.locateFixed,
                        color: Colors.black87,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Zoom in button
                  InkWell(
                    onTap: _zoomIn,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.plus,
                        color: Colors.black87,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Zoom out button
                  InkWell(
                    onTap: _zoomOut,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.minus,
                        color: Colors.black87,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ConfirmButton(
            text: 'common.save'.tr(),
            onPressed: _handleSave,
          ),
        ),
      ),
    );
  }
}
