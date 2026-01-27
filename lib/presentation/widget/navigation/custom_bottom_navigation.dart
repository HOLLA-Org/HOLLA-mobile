import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/core/config/themes/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  final List<IconData> icons = [
    LucideIcons.home,
    LucideIcons.heart,
    LucideIcons.alignLeft,
    LucideIcons.user2,
  ];

  final List<String> routes = [
    AppRoutes.home,
    AppRoutes.favorite,
    AppRoutes.bookinghistory,
    AppRoutes.setting,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () {
              setState(() => currentIndex = index);
              context.go(routes[index]);
            },
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration:
                  isSelected
                      ? BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      )
                      : null,
              child: Icon(
                icons[index],
                color: isSelected ? AppColors.white : Colors.grey[900],
                size: 28.sp,
              ),
            ),
          );
        }),
      ),
    );
  }
}
