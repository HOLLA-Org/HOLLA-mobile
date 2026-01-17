import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/config/themes/app_colors.dart';
import '../../../models/hotel_model.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';
import '../../widget/header_with_back.dart';
import '../../widget/home/hotel_card_list.dart';
import '../../widget/empty_list.dart';

class SearchScreen extends StatefulWidget {
  final String name;

  const SearchScreen({super.key, required this.name});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.name;
    _showClear = widget.name.isNotEmpty;
    context.read<SearchBloc>().add(SearchHotels(widget.name));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handle refresh
  void _onRefresh(BuildContext context) {
    context.read<SearchBloc>().add(SearchHotels(widget.name));
  }

  /// Handle clear
  void _onClear(BuildContext context) {
    _searchController.clear();
    setState(() => _showClear = false);
    context.read<SearchBloc>().add(ClearSearch());
  }

  /// Go to home screen
  void _onBack(BuildContext context) {
    context.go(AppRoutes.home);
  }

  /// Handle favorite tap
  void _handleFavoriteTap(HotelModel hotel) {
    if (hotel.isFavorite) {
      context.read<HomeBloc>().add(RemoveFavorite(hotel.id));
    } else {
      context.read<HomeBloc>().add(AddFavorite(hotel.id));
    }

    context.read<SearchBloc>().add(ToggleSearchFavorite(hotel.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWithBack(
        title: 'Tìm kiếm khách sạn',
        onBack: () => _onBack(context),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
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

                        // Search input
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
                              setState(() => _showClear = value.isNotEmpty);

                              if (value.trim().isEmpty) return;
                              context.read<SearchBloc>().add(
                                SearchHotels(value.trim()),
                              );
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
                ),

                const SizedBox(width: 10),

                // Refresh
                InkWell(
                  onTap: () {
                    _onRefresh(context);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.refreshCcw,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search result
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchSuccess) {
                  final hotels = state.hotels;

                  if (hotels.isEmpty) {
                    return const EmptyList(
                      title: 'Không tìm thấy khách sạn',
                      subtitle: 'Vui lòng thử từ khóa khác',
                      imagePath: 'assets/images/search/not_found_nurse.png',
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: hotels.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
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
                          isFavorite: hotel.isFavorite,
                          onFavoriteTap: () => _handleFavoriteTap(hotel),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
