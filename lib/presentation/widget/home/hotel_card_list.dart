import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/themes/app_colors.dart';

class HotelCardList extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final int ratingCount;
  final int priceHour;
  final String address;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const HotelCardList({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.priceHour,
    required this.address,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: 120.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image + Favorite
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.r),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 80.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Favorite icon
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 12.sp,
                          color: isFavorite ? Colors.red : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// Content
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    /// Rating
                    Row(
                      children: [
                        Icon(Icons.star, size: 12.sp, color: Colors.amber),
                        SizedBox(width: 2.w),
                        Text(
                          '$rating ($ratingCount)',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ],
                    ),

                    /// ADDRESS
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),

                    SizedBox(height: 1.h),

                    /// Price
                    Text(
                      '${"home.from".tr()} ${NumberFormat('#,###').format(priceHour)}đ /1${"home.hour_unit".tr()}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
