import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'HoLLa',
            style: TextStyle(
              color: const Color(0xFF008080),
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlayfairDisplay',
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, size: 28.sp, color: Colors.grey),
          onPressed: () {
            context.push(AppRoutes.notification);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
