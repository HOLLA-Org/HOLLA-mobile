import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return Center(child: Text(state.error));
          }

          if (state is GetAllFavoriteSuccess) {
            if (state.hotels.isEmpty) {
              return const EmptyList(
                title: 'Không tìm thấy khách sạn',
                subtitle: 'Vui lòng thử từ khóa khác',
                imagePath: 'assets/images/search/not_found_nurse.png',
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: state.hotels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
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

                    onTap: () {},
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
