import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    'CASH': {'name': 'checkout.cash'.tr(), 'icon': Icons.payments_outlined},
    'CREDIT': {'name': 'checkout.credit'.tr(), 'icon': Icons.credit_card},
    'ATM': {'name': 'checkout.atm'.tr(), 'icon': Icons.account_balance},
    'MOMO': {
      'name': 'checkout.momo'.tr(),
      'icon': Icons.account_balance_wallet,
    },
    'ZALOPAY': {
      'name': 'checkout.zalopay'.tr(),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
        content: Text('checkout.success_message'.tr()),
        backgroundColor: const Color(0xFF008080),
      ),
    );
    context.go(AppRoutes.home);
  }

  /// Show error notification
  void _showError(String message) {
    notificationDialog(
      context: context,
      title: 'checkout.failure_title'.tr(),
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
                blurRadius: 10.r,
                offset: Offset(0, -5.h),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).padding.bottom + 16.h,
            top: 12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _showPaymentPicker,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Icon(
                        _paymentMethods[_paymentMethod]!['icon'],
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _paymentMethods[_paymentMethod]!['name'],
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackTypo,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.h, color: AppColors.primary.withOpacity(0.5)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'checkout.total_payment'.tr(),
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 4.h),
                        if (_isDiscountApplied)
                          Text(
                            "${NumberFormat('#,###').format(_basePrice)}đ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          "${NumberFormat('#,###').format(_totalPrice)}đ",
                          style: TextStyle(
                            fontSize: 28.sp,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child:
                            isLoading
                                ? SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'checkout.confirm_button'.tr(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
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
          title: "checkout.title".tr(),
          onBack: () => context.pop(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            widget.args.hotel.images.isNotEmpty
                                ? widget.args.hotel.images.first
                                : 'https://res.cloudinary.com/dasiiuipv/image/upload/v1768381679/793131782_shbpba.jpg',
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.args.hotel.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.blackTypo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.args.hotel.address,
                                style: TextStyle(
                                  fontSize: 16.sp,
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
              SizedBox(height: 24.h),
              const Divider(thickness: 1, color: Colors.black12),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.hotel_outlined,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'booking_time.checkin'.tr(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  _checkInStr,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'booking_time.checkout'.tr(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  _checkOutStr,
                                  style: TextStyle(
                                    fontSize: 15.sp,
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
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'checkout.booker_info'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
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
                                  'edit_profile.phone'.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  phone,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'edit_profile.username'.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
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
              SizedBox(height: 24.h),
              const Divider(thickness: 1, color: Colors.black12),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    TextField(
                      controller: _discountController,
                      readOnly: true,
                      onTap: _showDiscountPicker,
                      decoration: InputDecoration(
                        hintText: 'checkout.select_discount'.tr(),
                        prefixIcon: Icon(
                          Icons.local_offer_outlined,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                          size: 30.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    if (_isDiscountApplied)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, left: 4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'checkout.discount_applied'.tr(
                                namedArgs: {
                                  'amount': NumberFormat(
                                    '#,###',
                                  ).format(_basePrice - _totalPrice),
                                },
                              ),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: _removeDiscount,
                              child: Text(
                                'checkout.remove_discount'.tr(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
    );
  }
}
