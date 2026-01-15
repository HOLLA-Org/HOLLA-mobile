import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/models/home_model.dart';
import 'package:holla/presentation/widget/home/hotel_card_large.dart';
import 'package:holla/presentation/widget/home/hotel_card_row.dart';
import 'package:holla/presentation/widget/home/hotel_card_small.dart';
import 'package:holla/presentation/widget/home/section_title.dart';

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
  List<HomeModel> _popularHotels = [];
  List<HomeModel> _recommendedHotels = [];
  List<HomeModel> _topRatedHotels = [];

  static const int _loopMultiplier = 1000;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<HomeBloc>();
    bloc.add(GetPopularHotels());
    bloc.add(GetRecommendedHotels());
    bloc.add(GetTopRatedHotels());
  }

  void _handlePopularViewAll(BuildContext context) {}

  void _handleRecommendedViewAll(BuildContext context) {}

  void _handleTopRatedViewAll(BuildContext context) {}

  void _showError(BuildContext context, String message) {
    notificationDialog(
      context: context,
      title: 'Có lỗi xảy ra',
      message: message,
      isError: true,
    );
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
                          children: const [
                            Icon(Icons.search, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Tên khách sạn',
                              style: TextStyle(color: Colors.grey),
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
                                onTap: () {},
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
                                  onTap: () {},
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
                                onTap: () {},
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
