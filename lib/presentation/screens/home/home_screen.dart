import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/models/hotel_model.dart';
import 'package:holla/presentation/bloc/search/search_bloc.dart';
import 'package:holla/presentation/bloc/search/search_event.dart';
import 'package:holla/presentation/screens/home/view_all_args.dart';
import 'package:holla/presentation/widget/home/hotel_card_large.dart';
import 'package:holla/presentation/widget/home/hotel_card_row.dart';
import 'package:holla/presentation/widget/home/hotel_card_small.dart';
import 'package:holla/presentation/widget/home/section_title.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/themes/app_colors.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../widget/header.dart';
import '../../widget/notification_dialog.dart';
import '../../widget/shimmer/home_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HotelModel> _popularHotels = [];
  List<HotelModel> _recommendedHotels = [];
  List<HotelModel> _topRatedHotels = [];

  bool _showClear = false;
  Timer? _searchDebounce;

  static const int _loopMultiplier = 1000;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<HomeBloc>();
    bloc.add(GetPopularHotels());
    bloc.add(GetRecommendedHotels());
    bloc.add(GetTopRatedHotels());
  }

  /// Go to view all screen
  void _handlePopularViewAll(BuildContext context) {
    context.go(
      AppRoutes.viewall,
      extra: ViewAllArgs(title: 'home.popular'.tr(), hotels: _popularHotels),
    );
  }

  /// Go to view all screen
  void _handleRecommendedViewAll(BuildContext context) {
    context.go(
      AppRoutes.viewall,
      extra: ViewAllArgs(
        title: 'home.recommended'.tr(),
        hotels: _recommendedHotels,
      ),
    );
  }

  /// Go to view all screen
  void _handleTopRatedViewAll(BuildContext context) {
    context.go(
      AppRoutes.viewall,
      extra: ViewAllArgs(title: 'home.top_rated'.tr(), hotels: _topRatedHotels),
    );
  }

  /// Handle search changed
  void _onSearchChanged(BuildContext context, String value) {
    setState(() {
      _showClear = value.isNotEmpty;
    });

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 600), () {
      if (value.trim().isEmpty) return;

      context.go(AppRoutes.search, extra: value.trim());
    });
  }

  /// Handle clear
  void _onClear(BuildContext context) {
    _searchController.clear();
    setState(() => _showClear = false);
    context.read<SearchBloc>().add(ClearSearch());
  }

  /// Handle favorite tap
  void _handleFavoriteTap(HotelModel hotel) {
    final bool wasFavorite = hotel.isFavorite;

    void toggle(List<HotelModel> list) {
      final index = list.indexWhere((h) => h.id == hotel.id);
      if (index == -1) return;

      list[index] = list[index].copyWith(isFavorite: !list[index].isFavorite);
    }

    setState(() {
      toggle(_popularHotels);
      toggle(_recommendedHotels);
      toggle(_topRatedHotels);
    });

    if (wasFavorite) {
      context.read<HomeBloc>().add(RemoveFavorite(hotel.id));
    } else {
      context.read<HomeBloc>().add(AddFavorite(hotel.id));
    }
  }

  /// Handle hotel tap
  void _handleHotelTap(HotelModel hotel) {
    context.push(AppRoutes.bookingdetail, extra: hotel.id);
  }

  /// Show error dialog
  void _showError(BuildContext context, String message) {
    notificationDialog(
      context: context,
      title: 'home.failure'.tr(),
      message: message,
      isError: true,
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeFailure) {
          _showError(context, state.error);
        }

        if (state is GetPopularHotelsSuccess) {
          setState(() => _popularHotels = state.hotels);
        }

        if (state is GetRecommendedHotelsSuccess) {
          setState(() => _recommendedHotels = state.hotels);
        }

        if (state is GetTopRatedHotelsSuccess) {
          setState(() => _topRatedHotels = state.hotels);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const Header(),
        body:
            (_popularHotels.isEmpty &&
                    _recommendedHotels.isEmpty &&
                    _topRatedHotels.isEmpty)
                ? const HomeSkeleton()
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle
                      Text(
                        'home.find_great_place'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Title
                      Text(
                        'home.hotels_for_you'.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5.w,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Search
                      Container(
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

                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                textInputAction: TextInputAction.search,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'home.search_hint'.tr(),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) {
                                  _onSearchChanged(context, value);
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

                      // Popular Hotels
                      if (_popularHotels.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        SectionTitle(
                          title: 'home.popular'.tr(),
                          onViewAll: () => _handlePopularViewAll(context),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 225.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _popularHotels.length * _loopMultiplier,
                            separatorBuilder: (_, __) => SizedBox(width: 12.w),
                            itemBuilder: (_, i) {
                              final hotel =
                                  _popularHotels[i % _popularHotels.length];

                              return HotelCardLarge(
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
                        ),
                      ],

                      // Top Rated Hotels
                      if (_topRatedHotels.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        SectionTitle(
                          title: 'home.top_rated'.tr(),
                          onViewAll: () => _handleTopRatedViewAll(context),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 165.h,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _topRatedHotels.length * _loopMultiplier,
                              separatorBuilder:
                                  (_, __) => SizedBox(width: 12.w),
                              itemBuilder: (_, i) {
                                final hotel =
                                    _topRatedHotels[i % _topRatedHotels.length];

                                return HotelCardSmall(
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
                                  onFavoriteTap:
                                      () => _handleFavoriteTap(hotel),
                                  onTap: () => _handleHotelTap(hotel),
                                );
                              },
                            ),
                          ),
                        ),
                      ],

                      // Recommended Hotels
                      if (_recommendedHotels.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        SectionTitle(
                          title: 'home.recommended'.tr(),
                          onViewAll: () => _handleRecommendedViewAll(context),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 195.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            itemCount:
                                _recommendedHotels.length * _loopMultiplier,
                            separatorBuilder: (_, __) => SizedBox(width: 12.w),
                            itemBuilder: (_, i) {
                              final hotel =
                                  _recommendedHotels[i %
                                      _recommendedHotels.length];

                              return HotelCardRow(
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
                        ),
                      ],

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
      ),
    );
  }
}
