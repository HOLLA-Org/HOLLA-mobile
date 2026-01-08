// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import 'package:holla/presentation/widget/header.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import '../../widget/setting/select_option_item.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  List<Locale> get supportedLocales => const [Locale('en'), Locale('vi')];

  Map<String, String> get languageNames => {
    'en': 'English'.tr(),
    'vi': 'Vietnamese'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final String currentLangCode = context.locale.languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            const Header(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'Chọn ngôn ngữ'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'CrimsonText',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// Language options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                    supportedLocales.map((locale) {
                      final code = locale.languageCode;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SelectOptionItem(
                          label: languageNames[code] ?? code,
                          value: code,
                          groupValue: currentLangCode,
                          onChanged: (selected) async {
                            if (selected == currentLangCode) return;

                            context.setLocale(Locale(selected));
                            context.go(AppRoutes.setting);
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
