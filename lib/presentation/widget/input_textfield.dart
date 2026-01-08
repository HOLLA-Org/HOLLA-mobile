import 'package:flutter/material.dart';

import '../../core/config/themes/app_colors.dart';

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool isPassword;
  final bool hasError;
  final String? errorText;
  final bool isEmailOrPhone;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? suffixText;
  final VoidCallback? onTap;

  const InputTextField({
    super.key,
    required this.controller,
    this.hint,
    this.label,
    this.isPassword = false,
    this.hasError = false,
    this.errorText,
    this.isEmailOrPhone = false,
    this.readOnly = false,
    this.keyboardType,
    this.suffixIcon,
    this.suffixText,
    this.onTap,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool _isObscured = true;
  bool _showSuffixIcon = false;
  late VoidCallback _textListener;

  @override
  void initState() {
    super.initState();
    _textListener = () {
      final shouldShow = widget.controller.text.isNotEmpty;
      if (shouldShow != _showSuffixIcon && mounted) {
        setState(() => _showSuffixIcon = shouldShow);
      }
    };
    widget.controller.addListener(_textListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        widget.hasError
            ? AppColors.error.withOpacity(0.6)
            : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty ?? false) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.blackTypo,
            ),
          ),
          SizedBox(height: 6),
        ],
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _isObscured : false,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: TextStyle(fontSize: 14, color: AppColors.headingTypo),
          decoration: InputDecoration(
            constraints: BoxConstraints(minHeight: 36),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.bodyTypo.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.hover,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color:
                    widget.hasError
                        ? AppColors.error.withOpacity(0.6)
                        : widget.isEmailOrPhone
                        ? Colors.grey.shade300
                        : AppColors.primary.withOpacity(0.5),
                width: widget.isEmailOrPhone ? 0.5 : 1.5,
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 8),
              child:
                  widget.suffixIcon ??
                  (widget.isPassword && _showSuffixIcon
                      ? IconButton(
                        icon: Icon(
                          _isObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed:
                            () => setState(() => _isObscured = !_isObscured),
                      )
                      : widget.suffixText != null
                      ? Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          widget.suffixText!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.headingTypo,
                          ),
                        ),
                      )
                      : null),
            ),
          ),
        ),
        if (widget.hasError && widget.errorText != null) ...[
          SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.error,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
