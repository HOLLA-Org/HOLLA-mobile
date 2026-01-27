import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  void _onContinuePressed(BuildContext context) {
    context.go(AppRoutes.googlemap);
  }

  void _onChooseLocationPressed(BuildContext context) {
    context.go(AppRoutes.selectlocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Title
              Text(
                "location_permission.title".tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              SizedBox(height: 16.h),

              // Subtitle
              Text(
                "location_permission.subtitle".tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'CrimsonText',
                ),
              ),

              // Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/logos/search_location.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 36.h),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008080),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () => _onContinuePressed(context),
                  child: Text(
                    "location_permission.continue_button".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () => _onChooseLocationPressed(context),
                  child: Text(
                    "location_permission.choose_location_button".tr(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
