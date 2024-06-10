import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'default_text_field.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField(
      {super.key,
      required this.lable,
      required this.hint,
      required this.passwordController,
      required this.onChanged,
      this.onVisibleButtonClick,
      this.isHidePassword = true,
      this.enableWarning = false,
      this.isActiveTextField = false,
      this.borderColor,
      this.prefixIconData,
      this.padding,
      this.focusNode,
      this.widgetWarning,
      this.onSubmitted});
  final TextEditingController passwordController;

  final VoidCallback? onVisibleButtonClick;
  bool isHidePassword;
  bool enableWarning;
  bool isActiveTextField;
  final Widget? widgetWarning;
  final String lable;
  final String hint;
  final Color? borderColor;
  Function onChanged;
  ValueChanged<String>? onSubmitted;
  EdgeInsets? padding;
  final IconData? prefixIconData;
  final FocusNode? focusNode;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isHidePassword = true;
  @override
  void initState() {
    isHidePassword = widget.isHidePassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            isHidePassword = !isHidePassword;
          });
        },
        icon: Icon(
          isHidePassword ? Icons.visibility_off : Icons.visibility,
          size: 18.h,
          color: Colors.grey,
        ),
      ),
      hintName: widget.hint,
      focusNode: widget.focusNode,
      controller: widget.passwordController,
      obscureText: isHidePassword,
      padding: widget.padding,
      keyboardType: TextInputType.visiblePassword,
      onChange: widget.onChanged,
    );
  }
}
