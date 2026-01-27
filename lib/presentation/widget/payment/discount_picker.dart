import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/discount_model.dart';
import '../../bloc/payment/payment_bloc.dart';
import '../../bloc/payment/payment_state.dart';
import '../../../core/config/themes/app_colors.dart';

class DiscountPicker extends StatelessWidget {
  final Function(DiscountModel) onSelected;

  const DiscountPicker({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                'checkout.available_discounts'.tr(),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state is GetDiscountsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetDiscountsSuccess) {
                    if (state.discounts.isEmpty) {
                      return Center(
                        child: Text(
                          'checkout.no_discounts'.tr(),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: state.discounts.length,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        DiscountModel discount = state.discounts[index];
                        return InkWell(
                          onTap: () {
                            onSelected(discount);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.local_offer_outlined,
                                    color: AppColors.primary,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        discount.code,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        discount.description,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '-${discount.value}%',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is GetDiscountsFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
