import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import '../../../../models/home_model.dart';
import '../../../../core/config/themes/app_colors.dart';
import '../../../../presentation/widget/header_with_back.dart';
import '../../widget/home/hotel_card_list.dart';

class ViewAllScreen extends StatelessWidget {
  final String title;
  final List<HomeModel> hotels;

  const ViewAllScreen({super.key, required this.title, required this.hotels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWithBack(
        title: title,
        onBack: () => context.go(AppRoutes.home),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 12),
          itemCount: hotels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 12,
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
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
