import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/config/routes/app_routes.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../widget/booking/action_button.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_event.dart';
import '../../bloc/booking/booking_state.dart';
import '../../../models/hotel_detail_model.dart';
import '../../../models/review_model.dart';
import '../../widget/review/review_card.dart';

class BookingDetailScreen extends StatefulWidget {
  final String hotelId;

  const BookingDetailScreen({super.key, required this.hotelId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  HotelDetailModel? _hotel;
  List<ReviewModel> _reviews = [];

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetHotelDetail(widget.hotelId));
    context.read<BookingBloc>().add(GetHotelReviews(widget.hotelId));
  }

  /// Navigate back to the previous screen
  void _handleNavigateBack() {
    context.pop(context);
  }

  /// Navigate to all reviews screen
  void _handleNavigateToAllReviews() {
    context.push(
      AppRoutes.review,
      extra: {
        'reviews': _reviews,
        'rating': _hotel!.rating,
        'ratingCount': _hotel!.ratingCount,
      },
    );
  }

  /// Handle booking action
  void _handleBooking() async {
    context.push(AppRoutes.bookingtime, extra: _hotel!);
  }

  void _showAllImages() {
    final images = _hotel!.images;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tất cả ảnh (${images.length})',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => context.pop(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: images.length,
                          itemBuilder:
                              (context, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Container(color: Colors.grey[300]),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is GetHotelDetailSuccess) {
            setState(() {
              _hotel = state.hotel;
            });
          } else if (state is GetHotelReviewsSuccess) {
            setState(() {
              _reviews = state.reviews;
            });
          } else if (state is BookingFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading && _hotel == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_hotel == null) {
              return const SizedBox();
            }

            return CustomScrollView(
              slivers: [
                // App Bar with Images
                _buildSliverAppBar(),

                // Hotel Info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          _hotel!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _hotel!.address,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Amenities
                        _buildAmenitiesSection(),
                        const SizedBox(height: 24),

                        // Policy
                        _buildPolicySection(),
                        const SizedBox(height: 24),

                        // Reviews
                        _buildReviewsSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _hotel != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: AppColors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        onPressed: _handleNavigateBack,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background:
            _hotel!.images.isNotEmpty
                ? _buildImageGallery()
                : Container(color: Colors.grey[300]),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = _hotel!.images;
    if (images.isEmpty) return const SizedBox();

    return Stack(
      children: [
        // Main large image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 80,
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    Container(color: Colors.grey[300]),
          ),
        ),
        // Bottom row of smaller images
        if (images.length > 1)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Row(
              children: [
                for (
                  int i = 1;
                  i < (images.length > 4 ? 4 : images.length);
                  i++
                )
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            images[i],
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Container(color: Colors.grey[300]),
                          ),
                          if (i == 3 && images.length > 4)
                            InkWell(
                              onTap: _showAllImages,
                              child: Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Text(
                                    '+${images.length - 4}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.hotel, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Tiện ích khách sạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_hotel!.amenities.isEmpty)
          const Text('Không có thông tin tiện ích')
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                _hotel!.amenities.map((amenity) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAmenityIcon(amenity.icon),
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          amenity.name,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
      ],
    );
  }

  Widget _buildPolicySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.info_outline, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Chính sách khách sạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Vui lòng đọc kỹ chính sách trước khi đặt phòng, các chính sách này được quy định bởi khách sạn.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Đánh giá',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  _hotel!.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '{${NumberFormat('#,###').format(_hotel!.ratingCount)} đánh giá}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            if (_reviews.isNotEmpty)
              TextButton(
                onPressed: _handleNavigateToAllReviews,
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(fontSize: 14, color: AppColors.primary),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_reviews.isEmpty)
          const Text(
            'Chưa có đánh giá nào',
            style: TextStyle(color: Colors.grey),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemCount: _reviews.length > 5 ? 5 : _reviews.length,
              itemBuilder: (context, index) {
                return ReviewCard(review: _reviews[index], width: 240);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giá phòng',
                    style: TextStyle(fontSize: 16, color: AppColors.bodyTypo),
                  ),

                  Text(
                    '${NumberFormat('#,###').format(_hotel!.priceHour)}đ / 1 giờ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackTypo,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ActionButton(text: 'Đặt phòng', onTap: _handleBooking),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'parking':
        return Icons.local_parking;
      case 'pool':
        return Icons.pool;
      case 'restaurant':
        return Icons.restaurant;
      case 'gym':
        return Icons.fitness_center;
      case 'spa':
        return Icons.spa;
      case 'ac':
      case 'air_conditioner':
        return Icons.ac_unit;
      case 'tv':
        return Icons.tv;
      default:
        return Icons.check_circle;
    }
  }
}
