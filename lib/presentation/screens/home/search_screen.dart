import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/themes/app_colors.dart';
import '../../../models/hotel_model.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';
import '../../widget/header_with_back.dart';
import '../../widget/home/hotel_card_list.dart';
import '../../widget/empty_list.dart';
import '../../widget/shimmer/hotel_card_list_skeleton.dart';

class SearchScreen extends StatefulWidget {
  final String name;

  const SearchScreen({super.key, required this.name});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.name;
    _showClear = widget.name.isNotEmpty;
    context.read<SearchBloc>().add(SearchHotels(widget.name));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handle refresh
  void _onRefresh(BuildContext context) {
    context.read<SearchBloc>().add(SearchHotels(widget.name));
  }

  /// Handle clear
  void _onClear(BuildContext context) {
    _searchController.clear();
    setState(() => _showClear = false);
    context.read<SearchBloc>().add(ClearSearch());
  }

  /// Go to home screen
  void _onBack(BuildContext context) {
    context.go(AppRoutes.home);
  }

  /// Handle favorite tap
  void _handleFavoriteTap(HotelModel hotel) {
    if (hotel.isFavorite) {
      context.read<HomeBloc>().add(RemoveFavorite(hotel.id));
    } else {
      context.read<HomeBloc>().add(AddFavorite(hotel.id));
    }

    context.read<SearchBloc>().add(ToggleSearchFavorite(hotel.id));
  }

  /// Handle hotel tap
  void _handleHotelTap(HotelModel hotel) {
    context.push(AppRoutes.bookingdetail, extra: hotel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWithBack(
        title: 'search.title'.tr(),
        onBack: () => _onBack(context),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.hover,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),

                        // Search input
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            textInputAction: TextInputAction.search,
                            style: TextStyle(fontSize: 14.sp),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'search.hint'.tr(),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              setState(() => _showClear = value.isNotEmpty);

                              if (value.trim().isEmpty) return;
                              context.read<SearchBloc>().add(
                                SearchHotels(value.trim()),
                              );
                            },
                          ),
                        ),

                        if (_showClear)
                          GestureDetector(
                            onTap: () {
                              _onClear(context);
                            },
                            child: Icon(
                              LucideIcons.xCircle,
                              size: 18.sp,
                              color: AppColors.error.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                // Refresh
                InkWell(
                  onTap: () {
                    _onRefresh(context);
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.refreshCcw,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search result
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: GridView.builder(
                      padding: EdgeInsets.only(top: 8.h),
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.88,
                      ),
                      itemBuilder: (context, index) {
                        return const HotelCardListSkeleton();
                      },
                    ),
                  );
                }

                if (state is SearchSuccess) {
                  final hotels = state.hotels;

                  if (hotels.isEmpty) {
                    return EmptyList(
                      title: 'search.empty_title'.tr(),
                      subtitle: 'search.empty_subtitle'.tr(),
                      imagePath: 'assets/images/search/not_found_hotel.png',
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: GridView.builder(
                      padding: EdgeInsets.only(top: 8.h),
                      itemCount: hotels.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.88,
                      ),
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];
                        return HotelCardList(
                          name: hotel.name,
                          imageUrl:
                              hotel.images.isNotEmpty
                                  ? hotel.images.first
                                  : 'https://res.cloudinary.com/dasiiuipv/image/upload/v1768381679/793131782_shbpba.jpg',
                          rating: hotel.rating,
                          ratingCount: hotel.ratingCount,
                          priceHour: hotel.priceHour,
                          address: hotel.address,
                          isFavorite: hotel.isFavorite,
                          onFavoriteTap: () => _handleFavoriteTap(hotel),
                          onTap: () => _handleHotelTap(hotel),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
