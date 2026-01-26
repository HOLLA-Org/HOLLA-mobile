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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'checkout.payment_method_title'.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...paymentMethods.entries.map((entry) {
            return ListTile(
              leading: Icon(entry.value['icon'], color: AppColors.primary),
              title: Text(entry.value['name']),
              trailing:
                  selectedMethod == entry.key
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
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
