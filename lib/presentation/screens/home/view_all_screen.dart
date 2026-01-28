import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/presentation/bloc/home/home_bloc.dart';
import 'package:holla/presentation/bloc/home/home_event.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/hotel_model.dart';
import '../../../../core/config/themes/app_colors.dart';
import '../../../../presentation/widget/header_with_back.dart';
import '../../widget/home/hotel_card_list.dart';
import '../../widget/shimmer/hotel_card_list_skeleton.dart';
import '../../bloc/home/home_state.dart';

class ViewAllScreen extends StatefulWidget {
  final String title;
  final List<HotelModel> hotels;

  const ViewAllScreen({super.key, required this.title, required this.hotels});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  late List<HotelModel> _hotels;

  @override
  void initState() {
    super.initState();
    _hotels = List<HotelModel>.from(widget.hotels);
  }

  /// Handle favorite tap
  void _handleFavoriteTap(HotelModel hotel) {
    final index = _hotels.indexWhere((h) => h.id == hotel.id);
    if (index == -1) return;

    final wasFavorite = _hotels[index].isFavorite;

    setState(() {
      _hotels[index] = _hotels[index].copyWith(isFavorite: !wasFavorite);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWithBack(
        title: widget.title,
        onBack: () => context.go(AppRoutes.home),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 12.h),
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.88,
                ),
                itemBuilder: (context, index) => const HotelCardListSkeleton(),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              padding: EdgeInsets.only(top: 12.h),
              itemCount: _hotels.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final hotel = _hotels[index];

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
        },
      ),
    );
  }
}
