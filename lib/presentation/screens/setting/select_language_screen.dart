// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/presentation/widget/header_with_back.dart';
import '../../widget/setting/select_option_item.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  List<Locale> get supportedLocales => const [Locale('en'), Locale('vi')];

  Map<String, String> getLanguageNames(BuildContext context) => {
    'en': 'setting.english'.tr(),
    'vi': 'setting.vietnamese'.tr(),
  };

  /// Handle back button
  void _handleBack(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final String currentLangCode = context.locale.languageCode;
    final languages = getLanguageNames(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWithBack(
              title: 'select_language.title'.tr(),
              onBack: () => _handleBack(context),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'select_language.select_label'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'CrimsonText',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// Language options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                    supportedLocales.map((locale) {
                      final code = locale.languageCode;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SelectOptionItem(
                          label: languages[code] ?? code,
                          value: code,
                          groupValue: currentLangCode,
                          onChanged: (selected) async {
                            if (selected == currentLangCode) return;

                            await context.setLocale(Locale(selected));

                            if (context.mounted) {
                              context.go(AppRoutes.setting);
                            }
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
