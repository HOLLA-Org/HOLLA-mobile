import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'hotel_detail.all_images'.tr(
                                args: [images.length.toString()],
                              ),
                              style: TextStyle(
                                fontSize: 18.sp,
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
                          padding: EdgeInsets.all(8.r),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 8.h,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: images.length,
                          itemBuilder:
                              (context, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
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

            final images = _hotel!.images;

            return CustomScrollView(
              slivers: [
                // App Bar with Images
                SliverAppBar(
                  expandedHeight: 220.h,
                  pinned: true,
                  leading: IconButton(
                    icon: CircleAvatar(
                      backgroundColor: AppColors.white,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24.sp,
                      ),
                    ),
                    onPressed: _handleNavigateBack,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        images.isNotEmpty
                            ? Stack(
                              children: [
                                // Main large image
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 80.h,
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
                                    height: 80.h,
                                    child: Row(
                                      children: [
                                        for (
                                          int i = 1;
                                          i <
                                              (images.length > 4
                                                  ? 4
                                                  : images.length);
                                          i++
                                        )
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(2.r),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Image.network(
                                                    images[i],
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                  ),
                                                  if (i == 3 &&
                                                      images.length > 4)
                                                    InkWell(
                                                      onTap: _showAllImages,
                                                      child: Container(
                                                        color: Colors.black54,
                                                        child: Center(
                                                          child: Text(
                                                            '+${images.length - 4}',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                            )
                            : Container(color: Colors.grey[300]),
                  ),
                ),

                // Hotel Info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          _hotel!.name,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                _hotel!.address,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Amenities
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.hotel,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'hotel_detail.services'.tr(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            if (_hotel!.amenities.isEmpty)
                              Text('hotel_detail.no_amenities'.tr())
                            else
                              Wrap(
                                spacing: 12.w,
                                runSpacing: 12.h,
                                children:
                                    _hotel!.amenities.map((amenity) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getAmenityIcon(amenity.icon),
                                              size: 18.sp,
                                              color: AppColors.primary,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              amenity.name,
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Policy
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'hotel_detail.policy_title'.tr(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'hotel_detail.policy_description'.tr(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Reviews
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'hotel_detail.reviews'.tr(),
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      _hotel!.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'hotel_detail.reviews_count'.tr(
                                        namedArgs: {
                                          'count': NumberFormat(
                                            '#,###',
                                          ).format(_hotel!.ratingCount),
                                        },
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_reviews.isNotEmpty)
                                  TextButton(
                                    onPressed: _handleNavigateToAllReviews,
                                    child: Text(
                                      'home.view_all'.tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            if (_reviews.isEmpty)
                              Text(
                                'hotel_detail.no_reviews'.tr(),
                                style: const TextStyle(color: Colors.grey),
                              )
                            else
                              SizedBox(
                                height: 100.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder:
                                      (context, index) => SizedBox(width: 16.w),
                                  itemCount:
                                      _reviews.length > 5 ? 5 : _reviews.length,
                                  itemBuilder: (context, index) {
                                    return ReviewCard(
                                      review: _reviews[index],
                                      width: 240.w,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar:
          _hotel != null
              ? Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10.r,
                      offset: Offset(0, -3.h),
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
                            Text(
                              'hotel_detail.price_label'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.bodyTypo,
                              ),
                            ),

                            Text(
                              '${NumberFormat('#,###').format(_hotel!.priceHour)}đ / 1 giờ',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackTypo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ActionButton(
                      text: 'booking_time.confirm_button'.tr(),
                      onTap: _handleBooking,
                    ),
                  ],
                ),
              )
              : null,
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
