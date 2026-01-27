import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/models/hotel_model.dart';
import 'package:holla/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:holla/presentation/bloc/favorite/favorite_event.dart';
import 'package:holla/presentation/bloc/favorite/favorite_state.dart';
import 'package:holla/presentation/widget/empty_list.dart';

import '../../../../core/config/themes/app_colors.dart';
import '../../../../presentation/widget/header.dart';
import '../../widget/home/hotel_card_list.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(GetAllFavorite());
  }

  /// Handle hotel tap
  void _handleHotelTap(HotelModel hotel) {
    context.push(AppRoutes.bookingdetail, extra: hotel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const Header(),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteFailure) {
            return Center(
              child: Text(state.error, style: TextStyle(fontSize: 14.sp)),
            );
          }

          if (state is GetAllFavoriteSuccess) {
            if (state.hotels.isEmpty) {
              return EmptyList(
                title: 'search.empty_title'.tr(),
                subtitle: 'search.empty_subtitle'.tr(),
                imagePath: 'assets/images/search/not_found_hotel.png',
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 12.h),
                itemCount: state.hotels.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.88,
                ),
                itemBuilder: (context, index) {
                  final hotel = state.hotels[index];

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
                    isFavorite: true,
                    onFavoriteTap: () {
                      context.read<FavoriteBloc>().add(
                        RemoveFavorite(hotel.id),
                      );
                    },
                    onTap: () => _handleHotelTap(hotel),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
