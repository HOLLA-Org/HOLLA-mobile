import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/routes/app_routes.dart';
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
    LucideIcons.heart,
    LucideIcons.alignLeft,
    LucideIcons.home,
    LucideIcons.user2,
    LucideIcons.settings,
  ];

  final List<String> routes = [
    AppRoutes.favorite,
    AppRoutes.booking,
    AppRoutes.home,
    AppRoutes.profile,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
              padding: const EdgeInsets.all(10),
              decoration:
                  isSelected
                      ? BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Color(0xFF238C98).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      )
                      : null,
              child: Icon(
                icons[index],
                color: isSelected ? Color(0xFF238C98) : Colors.grey[900],
                size: 28,
              ),
            ),
          );
        }),
      ),
    );
  }
}
