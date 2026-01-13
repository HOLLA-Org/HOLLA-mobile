import 'package:flutter/material.dart';
import '../../core/config/themes/app_colors.dart';

class HeaderWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;
  final bool showBack;
  final bool showMore;

  const HeaderWithBack({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
    this.showBack = true,
    this.showMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      // Title
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.blackTypo,
          // fontFamily: '',
        ),
      ),

      // Back icon
      leading:
          showBack
              ? InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: onBack,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.disableTypo,
                    size: 22,
                  ),
                ),
              )
              : null,

      // More icon
      actions:
          showMore
              ? [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: onMore,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.disableTypo,
                      size: 22,
                    ),
                  ),
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
