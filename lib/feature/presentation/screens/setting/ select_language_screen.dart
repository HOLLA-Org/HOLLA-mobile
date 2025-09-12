// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/feature/presentation/widget/header.dart';
import 'package:holla/config/routes/app_routes.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  List<Locale> get supportedLocales => const [Locale('en'), Locale('vi')];

  Map<String, String> get languageNames => {
    'en': 'English'.tr(),
    'vi': 'Vietnamese'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    Widget buildLanguageTile(Locale locale) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                locale == currentLocale
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
            width: 1.5,
          ),
        ),
        child: RadioListTile<Locale>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            languageNames[locale.languageCode] ?? locale.languageCode,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              fontFamily: 'CrimsonText',
              color: Color(0xFF8F8F8F),
            ),
          ),
          value: locale,
          groupValue: currentLocale,
          activeColor: Color(0xFF008080),
          onChanged: (newLocale) {
            context.setLocale(newLocale!);
            context.go(AppRoutes.setting);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            const Header(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                'Chọn ngôn ngữ'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'CrimsonText',
                  color: Color(0xFF8F8F8F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...supportedLocales.map(buildLanguageTile),
          ],
        ),
      ),
    );
  }
}
