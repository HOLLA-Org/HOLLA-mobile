import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/core/config/themes/app_colors.dart';
import 'package:holla/models/location_model.dart';
import 'package:holla/presentation/bloc/location/location_bloc.dart';
import 'package:holla/presentation/bloc/location/location_event.dart';
import 'package:holla/presentation/bloc/location/location_state.dart';
import 'package:holla/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_event.dart';
import 'package:holla/presentation/bloc/setting/setting_state.dart';
import 'package:holla/presentation/widget/header_with_back.dart';

String removeDiacritics(String str) {
  const vietnameseMap = {
    'a': 'áàảãạâấầẩẫậăắằẳẵặ',
    'e': 'éèẻẽẹêếềểễệ',
    'i': 'íìỉĩị',
    'o': 'óòỏõọôốồổỗộơớờởỡợ',
    'u': 'úùủũụưứừửữự',
    'y': 'ýỳỷỹỵ',
    'd': 'đ',
  };
  String result = str.toLowerCase();
  vietnameseMap.forEach((key, value) {
    for (var ch in value.split('')) {
      result = result.replaceAll(ch, key);
    }
  });
  return result;
}

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LocationModel? selectedLocation;
  Timer? _debounce;

  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> filteredLocations = [];
  List<LocationModel> allLocations = [];

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(LocationFetchAll());
  }

  void _handleBackPressed(BuildContext context) {
    context.go(AppRoutes.locationpermission);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final normalizedQuery = removeDiacritics(query);

      setState(() {
        filteredLocations =
            allLocations.where((location) {
              final normalizedLocation = removeDiacritics(location.name);
              return normalizedLocation.contains(normalizedQuery);
            }).toList();
      });
    });
  }

  void _handleConfirm() {
    if (selectedLocation != null) {
      context.read<SettingBloc>().add(
        UpdateProfileSubmitted(
          locationName: selectedLocation!.name,
          address: selectedLocation!.address,
          latitude: selectedLocation!.latitude,
          longitude: selectedLocation!.longitude,
        ),
      );
    }
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
      backgroundColor: Colors.white,
      appBar: HeaderWithBack(
        title: 'location_selection.location'.tr(),
        onBack: () => _handleBackPressed(context),
      ),
      body: BlocListener<SettingBloc, SettingState>(
        listener: (context, settingState) {
          if (settingState is UpdateProfileSuccess) {
            context.go(AppRoutes.loading);
          } else if (settingState is UpdateProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(settingState.error)));
          }
        },
        child: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state.locations.isNotEmpty && allLocations.isEmpty) {
              setState(() {
                allLocations = state.locations;
                filteredLocations = state.locations;
              });
            }
          },
          builder: (context, state) {
            if (state.loading && allLocations.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && allLocations.isEmpty) {
              return Center(child: Text('Error: ${state.error}'));
            }

            final popularLocations =
                filteredLocations.where((l) => l.isPopular).toList();
            final otherLocations =
                filteredLocations.where((l) => !l.isPopular).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "location_selection.title".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                      Text(
                        "location_selection.subtitle".tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'CrimsonText',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "location_selection.search_hint".tr(),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFEDEDED),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                    tooltip: 'Clear',
                                  )
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<LocationBloc>().add(LocationFetchAll());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (popularLocations.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                "location_selection.popular".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'CrimsonText',
                                ),
                              ),
                            ),
                            ...popularLocations.map(
                              (loc) => ListTile(
                                title: Text(
                                  loc.name,
                                  style: TextStyle(
                                    color:
                                        selectedLocation?.id == loc.id
                                            ? AppColors.primary
                                            : Colors.black,
                                    fontWeight:
                                        selectedLocation?.id == loc.id
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                trailing:
                                    selectedLocation?.id == loc.id
                                        ? const Icon(
                                          Icons.check_circle,
                                          color: AppColors.primary,
                                        )
                                        : null,
                                onTap:
                                    () =>
                                        setState(() => selectedLocation = loc),
                              ),
                            ),
                          ],
                          if (otherLocations.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                "location_selection.others".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'CrimsonText',
                                ),
                              ),
                            ),
                            ...otherLocations.map(
                              (loc) => ListTile(
                                title: Text(
                                  loc.name,
                                  style: TextStyle(
                                    color:
                                        selectedLocation?.id == loc.id
                                            ? AppColors.primary
                                            : Colors.black,
                                    fontWeight:
                                        selectedLocation?.id == loc.id
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                trailing:
                                    selectedLocation?.id == loc.id
                                        ? const Icon(
                                          Icons.check_circle,
                                          color: AppColors.primary,
                                        )
                                        : null,
                                onTap:
                                    () =>
                                        setState(() => selectedLocation = loc),
                              ),
                            ),
                          ],
                          if (filteredLocations.isEmpty && !state.loading)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(child: Text("No locations found")),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: BlocBuilder<SettingBloc, SettingState>(
                            builder: (context, settingState) {
                              final isUpdating = settingState is SettingLoading;

                              return ElevatedButton(
                                onPressed:
                                    selectedLocation == null || isUpdating
                                        ? null
                                        : _handleConfirm,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                  backgroundColor:
                                      selectedLocation == null
                                          ? Colors.grey
                                          : AppColors.primary,
                                ),
                                child:
                                    isUpdating
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Text(
                                          "location_selection.confirm_button"
                                              .tr(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'CrimsonText',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
