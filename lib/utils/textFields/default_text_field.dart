import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultTextField extends StatelessWidget {
  final String? hintName;
  final Function  onChange;
  final TextEditingController controller;
  final int? maxLength;
  final IconButton? suffixIcon;
  final IconButton? prefixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final bool? isPhone;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final FocusNode? focusNode;

  const DefaultTextField({
    super.key,
    required this.hintName,
    required this.onChange,
    required this.controller,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.readOnly,
    this.isPhone,
    this.keyboardType,
    this.textAlign,
    this.padding,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (String value) {
        onChange.call(value);
      },
      cursorColor: Colors.transparent,
      readOnly: readOnly ?? false,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(16.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(16.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(16.r),
          ),
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              EdgeInsets.only(left: 8.w, bottom: 12.h, top: 12.h, right: 8.w),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintStyle: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 14.sp, color: Colors.black),
          hintText: hintName),
      obscureText: obscureText ?? false,
    );
  }
}
