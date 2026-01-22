import 'dart:async';

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

import '../../../core/config/themes/app_colors.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../widget/header.dart';
import '../../widget/notification_dialog.dart';

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
      extra: ViewAllArgs(title: 'Nổi tiếng', hotels: _popularHotels),
    );
  }

  /// Go to view all screen
  void _handleRecommendedViewAll(BuildContext context) {
    context.go(
      AppRoutes.viewall,
      extra: ViewAllArgs(title: 'Gợi ý gần bạn', hotels: _recommendedHotels),
    );
  }

  /// Go to view all screen
  void _handleTopRatedViewAll(BuildContext context) {
    context.go(
      AppRoutes.viewall,
      extra: ViewAllArgs(title: 'Top bình chọn', hotels: _topRatedHotels),
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
      title: 'Có lỗi xảy ra',
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
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Tìm kiếm nơi tuyệt vời',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Title
                      Text(
                        'Khách sạn cho bạn',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Search
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.hover,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppColors.primary),
                            const SizedBox(width: 8),

                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                textInputAction: TextInputAction.search,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Tên khách sạn',
                                  hintStyle: TextStyle(color: Colors.grey),
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
                                  size: 18,
                                  color: AppColors.error.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Popular Hotels
                      if (_popularHotels.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        SectionTitle(
                          title: 'Nổi tiếng',
                          onViewAll: () => _handlePopularViewAll(context),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 265,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _popularHotels.length * _loopMultiplier,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 12),
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
                        const SizedBox(height: 20),
                        SectionTitle(
                          title: 'Top bình chọn',
                          onViewAll: () => _handleTopRatedViewAll(context),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 185,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _topRatedHotels.length * _loopMultiplier,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 12),
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
                        const SizedBox(height: 20),
                        SectionTitle(
                          title: 'Gợi ý gần bạn',
                          onViewAll: () => _handleRecommendedViewAll(context),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            itemCount:
                                _recommendedHotels.length * _loopMultiplier,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 12),
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

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
      ),
    );
  }
}
