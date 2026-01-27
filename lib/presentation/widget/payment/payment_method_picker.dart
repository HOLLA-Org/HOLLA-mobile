import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/config/themes/app_colors.dart';

class PaymentMethodPicker extends StatelessWidget {
  final Map<String, Map<String, dynamic>> paymentMethods;
  final String selectedMethod;
  final Function(String) onSelected;

  const PaymentMethodPicker({
    super.key,
    required this.paymentMethods,
    required this.selectedMethod,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'checkout.payment_method_title'.tr(),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          ...paymentMethods.entries.map((entry) {
            return ListTile(
              leading: Icon(
                entry.value['icon'],
                color: AppColors.primary,
                size: 24.sp,
              ),
              title: Text(
                entry.value['name'],
                style: TextStyle(fontSize: 14.sp),
              ),
              trailing:
                  selectedMethod == entry.key
                      ? Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20.sp,
                      )
                      : null,
              onTap: () {
                onSelected(entry.key);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}
