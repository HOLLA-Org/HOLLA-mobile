import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/widget/empty_list.dart';

import '../../../core/config/routes/app_routes.dart';
import '../../../models/booking_model.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_event.dart';
import '../../bloc/booking/booking_state.dart';
import '../../widget/header.dart';
import '../../widget/home/hotel_card_row.dart';
import '../../widget/notification_dialog.dart';
import '../../widget/booking/booking_tab_item.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  BookingStatus _selectedStatus = BookingStatus.active;
  bool _isFirstLoad = true;

  // Cache arrays for each status
  List<BookingModel> _activeBookings = [];
  List<BookingModel> _completedBookings = [];
  List<BookingModel> _cancelledBookings = [];
  List<BookingModel> _pendingBookings = [];

  @override
  void initState() {
    super.initState();
    if (_isFirstLoad) {
      _fetchHistory();
      _isFirstLoad = false;
    }
  }

  /// Get cached bookings based on status
  List<BookingModel> _getCachedBookings() {
    switch (_selectedStatus) {
      case BookingStatus.active:
        return _activeBookings;
      case BookingStatus.completed:
        return _completedBookings;
      case BookingStatus.cancelled:
        return _cancelledBookings;
      case BookingStatus.pending:
        return _pendingBookings;
    }
  }

  /// Update cache based on status
  void _updateCache(List<BookingModel> bookings) {
    switch (_selectedStatus) {
      case BookingStatus.active:
        _activeBookings = bookings;
        break;
      case BookingStatus.completed:
        _completedBookings = bookings;
        break;
      case BookingStatus.cancelled:
        _cancelledBookings = bookings;
        break;
      case BookingStatus.pending:
        _pendingBookings = bookings;
        break;
    }
  }

  /// Fetch booking history
  void _fetchHistory() {
    context.read<BookingBloc>().add(GetBookingHistory(_selectedStatus));
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    _fetchHistory();
    // Wait for the BLoC to finish loading
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Handle tab selection
  void _handleTabSelection(BookingStatus status) {
    setState(() {
      _selectedStatus = status;
    });
    _fetchHistory();
  }

  /// Handles rebooking action
  void _handleRebook(String hotelId) {
    context.push(AppRoutes.bookingdetail, extra: hotelId);
  }

  /// Handles review action
  void _handleReview(String bookingId) {
    context.push(AppRoutes.writereview, extra: bookingId);
  }

  /// Show error notification
  void _showError(String message) {
    notificationDialog(
      context: context,
      title: 'Lỗi',
      message: message,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              'Phòng của tôi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: Colors.black87,
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                BookingTabItem(
                  label: 'Hoạt động',
                  isSelected: _selectedStatus == BookingStatus.active,
                  onTap: () => _handleTabSelection(BookingStatus.active),
                ),
                const SizedBox(width: 12),
                BookingTabItem(
                  label: 'Đã hoàn thành',
                  isSelected: _selectedStatus == BookingStatus.completed,
                  onTap: () => _handleTabSelection(BookingStatus.completed),
                ),
                const SizedBox(width: 12),
                BookingTabItem(
                  label: 'Đã hủy',
                  isSelected: _selectedStatus == BookingStatus.cancelled,
                  onTap: () => _handleTabSelection(BookingStatus.cancelled),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BlocConsumer<BookingBloc, BookingState>(
              listener: (context, state) {
                if (state is BookingFailure) {
                  _showError(state.error);
                } else if (state is GetBookingHistorySuccess) {
                  _updateCache(state.bookings);
                }
              },
              builder: (context, state) {
                if (state is BookingLoading && _isFirstLoad) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Get cached bookings
                final cachedBookings = _getCachedBookings();

                if (cachedBookings.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: const EmptyList(
                      title: 'Không có lịch sử',
                      subtitle:
                          'Bạn chưa có đặt phòng nào trong danh sách này.',
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: cachedBookings.length,
                    itemBuilder: (context, index) {
                      final booking = cachedBookings[index];
                      final hotel = booking.hotel;
                      final isCancelled =
                          booking.status == BookingStatus.cancelled;
                      final isCompleted =
                          booking.status == BookingStatus.completed;

                      return HotelCardRow(
                        name: hotel.name,
                        imageUrl:
                            hotel.images.isNotEmpty
                                ? hotel.images.first
                                : 'https://via.placeholder.com/150',
                        rating: hotel.rating,
                        ratingCount: hotel.ratingCount,
                        priceHour: hotel.priceHour,
                        address: hotel.address,
                        showFavorite: false,
                        isCancelled: isCancelled,
                        isCompleted: isCompleted,
                        onRebook: () => _handleRebook(hotel.id),
                        onReview: () => _handleReview(booking.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
