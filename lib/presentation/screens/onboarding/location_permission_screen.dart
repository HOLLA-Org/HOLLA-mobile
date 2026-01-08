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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              // Title
              const Text(
                "Cho HoLLa biết bạn đang ở đâu nhé !",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              const Text(
                "Chỉ khi bạn cho phép truy cập vị trí, HoLLa mới có thể cung cấp những khách sạn phù hợp nhất và ưu đãi hấp dẫn trong khu vực cho bạn.",
                style: TextStyle(
                  fontSize: 16,
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
              const SizedBox(height: 40),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008080),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _onContinuePressed(context),
                  child: const Text(
                    "Tiếp tục",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _onChooseLocationPressed(context),
                  child: const Text(
                    "Chọn địa điểm",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
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
