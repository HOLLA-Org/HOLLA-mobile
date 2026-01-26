import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/presentation/widget/header_with_back.dart';

String removeDiacritics(String str) {
  const vietnameseMap = {
    'a': 'áàảãạâấầẩẫậăắằẳẵặ',
    'e': 'éèẻẽẹêếềểễệ',
    'i': 'íìỉĩị',
    'o': 'óòỏõọôốồổỗộơớờởỡợ',
    'u': 'úùủũụưứừửữự',
    'y': 'ýỳỷỹỵ',
    'd': 'đ',
  };
  String result = str.toLowerCase();
  vietnameseMap.forEach((key, value) {
    for (var ch in value.split('')) {
      result = result.replaceAll(ch, key);
    }
  });
  return result;
}

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? selectedLocation;
  Timer? _debounce;

  final TextEditingController _searchController = TextEditingController();
  late List<String> filteredLocations;

  final List<String> popularLocations = ["Hà Nội", "Hồ Chí Minh"];

  final List<String> otherLocations = [
    "Tuyên Quang",
    "Cao Bằng",
    "Lai Châu",
    "Lào Cai",
    "Thái Nguyên",
    "Điện Biên",
    "Lạng Sơn",
    "Sơn La",
    "Phú Thọ",
    "Bắc Ninh",
    "Quảng Ninh",
    "Hải Phòng",
    "Hưng Yên",
    "Ninh Bình",
    "Thanh Hóa",
    "Nghệ An",
    "Hà Tĩnh",
    "Quảng Trị",
    "Huế",
    "Đà Nẵng",
    "Quảng Ngãi",
    "Gia Lai",
    "Đắk Lắk",
    "Khánh Hòa",
    "Lâm Đồng",
    "Đồng Nai",
    "Tây Ninh",
    "Đồng Tháp",
    "An Giang",
    "Vĩnh Long",
    "Cần Thơ",
    "Cà Mau",
  ];

  @override
  void initState() {
    super.initState();
    filteredLocations = List.from(otherLocations);
  }

  void _handleBackPressed(BuildContext context) {
    context.go(AppRoutes.locationpermission);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final normalizedQuery = removeDiacritics(query);

      setState(() {
        filteredLocations =
            otherLocations.where((location) {
              final normalizedLocation = removeDiacritics(location);
              return normalizedLocation.contains(normalizedQuery);
            }).toList();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderWithBack(
        title: 'location_selection.location'.tr(),
        onBack: () => _handleBackPressed(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "location_selection.title".tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                Text(
                  "location_selection.subtitle".tr(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'CrimsonText',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "location_selection.search_hint".tr(),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF238C98),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFEDEDED),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              tooltip: 'Clear',
                            )
                            : null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "location_selection.popular".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'CrimsonText',
                      ),
                    ),
                  ),
                  ...popularLocations.map(
                    (loc) => ListTile(
                      title: Text(loc),
                      onTap: () => setState(() => selectedLocation = loc),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "location_selection.others".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'CrimsonText',
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        filteredLocations
                            .map(
                              (loc) => ListTile(
                                title: Text(loc),
                                onTap:
                                    () =>
                                        setState(() => selectedLocation = loc),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 100.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: ElevatedButton(
                      onPressed:
                          selectedLocation == null
                              ? null
                              : () => context.go(AppRoutes.loading),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor:
                            selectedLocation == null
                                ? Colors.grey
                                : const Color(0xFF238C98),
                      ),
                      child: Text(
                        "location_selection.confirm_button".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'CrimsonText',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
