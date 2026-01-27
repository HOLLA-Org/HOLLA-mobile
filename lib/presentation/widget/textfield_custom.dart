import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool hasError;

  const TextFieldCustom({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.hasError = false,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.hasError ? Colors.red : Colors.grey;
    final Color inactiveColor = widget.hasError ? Colors.red : Colors.grey;

    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      textAlignVertical: TextAlignVertical.bottom,
      style: TextStyle(fontSize: 16.sp, fontFamily: 'CrimsonText'),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 16.w, top: 8.h),
          child: Icon(widget.prefixIcon, color: Colors.grey, size: 24.sp),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: EdgeInsets.only(top: 10.h, bottom: 8.h),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.sp,
          fontFamily: 'CrimsonText',
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
                : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: inactiveColor, width: 1.0.w),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: activeColor, width: 1.0.w),
        ),
      ),
    );
  }
}
