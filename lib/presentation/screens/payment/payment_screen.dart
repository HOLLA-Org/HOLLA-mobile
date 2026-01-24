import 'package:easy_localization/easy_localization.dart';
import '../../../core/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'payment_args.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../widget/header_with_back.dart';
import '../../bloc/payment/payment_bloc.dart';
import '../../bloc/payment/payment_event.dart';
import '../../bloc/payment/payment_state.dart';
import '../../widget/notification_dialog.dart';
import '../../bloc/setting/setting_bloc.dart';
import '../../bloc/setting/setting_event.dart';
import '../../bloc/setting/setting_state.dart';
import '../../../models/discount_model.dart';
import '../../widget/payment/payment_method_picker.dart';
import '../../widget/payment/discount_picker.dart';

class PaymentScreen extends StatefulWidget {
  final PaymentArgs args;

  const PaymentScreen({super.key, required this.args});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'CASH';
  final TextEditingController _discountController = TextEditingController();
  final int _discountAmount = 0;
  double _discountPercent = 0.0;
  bool _isDiscountApplied = false;

  final Map<String, Map<String, dynamic>> _paymentMethods = {
    'CASH': {'name': 'Tiền mặt', 'icon': Icons.payments_outlined},
    'CREDIT': {'name': 'Thẻ tín dụng', 'icon': Icons.credit_card},
    'ATM': {'name': 'Thẻ ATM', 'icon': Icons.account_balance},
    'MOMO': {'name': 'Ví MoMo', 'icon': Icons.account_balance_wallet},
    'ZALOPAY': {
      'name': 'ZaloPay',
      'icon': Icons.account_balance_wallet_outlined,
    },
  };

  /// Get base price before discount
  int get _basePrice {
    if (widget.args.isHourly) {
      return widget.args.hotel.priceHour * (widget.args.duration ?? 1);
    } else {
      if (widget.args.selectedRange == null) return 0;
      final days = widget.args.selectedRange!.duration.inDays;
      return widget.args.hotel.priceDay * (days > 0 ? days : 1);
    }
  }

  /// Calculate total price after discount
  int get _totalPrice {
    int price = _basePrice;
    if (_discountPercent > 0) {
      price = (price * (1 - _discountPercent)).toInt();
    }
    price -= _discountAmount;
    return price > 0 ? price : 0;
  }

  /// Get formatted check-in string
  String get _checkInStr {
    if (widget.args.isHourly) {
      if (widget.args.selectedDay == null) return "";
      return "${widget.args.time} • ${DateFormat('dd/MM/yyyy').format(widget.args.selectedDay!)}";
    } else {
      if (widget.args.selectedRange == null) return "";
      return "12:00 • ${DateFormat('dd/MM/yyyy').format(widget.args.selectedRange!.start)}";
    }
  }

  /// Get formatted check-out string
  String get _checkOutStr {
    if (widget.args.isHourly) {
      if (widget.args.selectedDay == null) return "";
      final timeParts = (widget.args.time ?? "00:00").split(":");
      final checkInTime = DateTime(
        widget.args.selectedDay!.year,
        widget.args.selectedDay!.month,
        widget.args.selectedDay!.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      final checkOutTime = checkInTime.add(
        Duration(hours: widget.args.duration ?? 0),
      );
      return "${DateFormat('HH:mm').format(checkOutTime)} • ${DateFormat('dd/MM/yyyy').format(checkOutTime)}";
    } else {
      if (widget.args.selectedRange == null) return "";
      return "12:00 • ${DateFormat('dd/MM/yyyy').format(widget.args.selectedRange!.end)}";
    }
  }

  /// Apply discount locally
  void _applyDiscount(DiscountModel discount) {
    setState(() {
      _discountController.text = discount.code;
      _isDiscountApplied = true;
      _discountPercent = discount.value / 100.0;
    });
  }

  /// Remove applied discount
  void _removeDiscount() {
    setState(() {
      _discountController.clear();
      _isDiscountApplied = false;
      _discountPercent = 0.0;
    });
  }

  /// Process booking/payment
  void _handleBooking() {
    context.read<PaymentBloc>().add(
      CreatePaymentRequest(
        bookingId: widget.args.bookingId,
        paymentMethod: _paymentMethod,
        discountCode:
            _discountController.text.trim().isEmpty
                ? null
                : _discountController.text.trim(),
      ),
    );
  }

  /// Open payment method picker
  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PaymentMethodPicker(
          paymentMethods: _paymentMethods,
          selectedMethod: _paymentMethod,
          onSelected: (method) {
            setState(() => _paymentMethod = method);
          },
        );
      },
    );
  }

  /// Open discount picker
  void _showDiscountPicker() {
    context.read<PaymentBloc>().add(GetDiscounts());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DiscountPicker(onSelected: _applyDiscount);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(GetUserProfile());
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  /// Show success notification and navigate home
  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đặt phòng và thanh toán thành công!'),
        backgroundColor: const Color(0xFF008080),
      ),
    );
    context.go(AppRoutes.home);
  }

  /// Show error notification
  void _showError(String message) {
    notificationDialog(
      context: context,
      title: 'Lỗi thanh toán',
      message: message,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          _showSuccess(context);
        } else if (state is PaymentFailure) {
          _showError(state.error);
        } else if (state is GetDiscountsFailure) {
          _showError(state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _showPaymentPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        _paymentMethods[_paymentMethod]!['icon'],
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _paymentMethods[_paymentMethod]!['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackTypo,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: AppColors.primary.withOpacity(0.5)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng thanh toán',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        if (_isDiscountApplied)
                          Text(
                            "${NumberFormat('#,###').format(_basePrice)}đ",
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          "${NumberFormat('#,###').format(_totalPrice)}đ",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, paymentState) {
                      bool isLoading = paymentState is PaymentLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _handleBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Đặt phòng',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        appBar: HeaderWithBack(
          title: "Xác nhận và thanh toán",
          onBack: () => context.pop(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.args.hotel.images.isNotEmpty
                                ? widget.args.hotel.images.first
                                : 'https://res.cloudinary.com/dasiiuipv/image/upload/v1768381679/793131782_shbpba.jpg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.args.hotel.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColors.blackTypo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.args.hotel.address,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.hotel_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nhận phòng:',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  _checkInStr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trả phòng:',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  _checkOutStr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Người đặt phòng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SettingBloc, SettingState>(
                      builder: (context, state) {
                        String phone = "+84 338978783";
                        String name = "Vi Hồng Minh";

                        if (state is GetUserProfileSuccess) {
                          phone = state.user.phone ?? phone;
                          name = state.user.username ?? name;
                        }

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Số điện thoại',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Họ tên',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextField(
                      controller: _discountController,
                      readOnly: true,
                      onTap: _showDiscountPicker,
                      decoration: InputDecoration(
                        hintText: 'Chọn mã giảm giá',
                        prefixIcon: const Icon(
                          Icons.local_offer_outlined,
                          color: AppColors.primary,
                        ),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                          size: 30,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    if (_isDiscountApplied)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đã giảm: ${NumberFormat('#,###').format(_basePrice - _totalPrice)}đ',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: _removeDiscount,
                              child: const Text(
                                'Gỡ mã',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
