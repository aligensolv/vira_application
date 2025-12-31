import 'package:flutter/material.dart';
import 'package:vira/core/config/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final double? customHeight;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLines,
    this.readOnly = false,
    this.onTap,
    this.customHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: customHeight,
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black26,
      //       blurRadius: 1,
      //       // spreadRadius: 1,
      //       offset: Offset(1, 1)
      //     ),
      //     BoxShadow(
      //       color: Colors.black26,
      //       blurRadius: 0.5,
      //       // spreadRadius: 1,
      //       offset: Offset(-0.5, 0)
      //     ),

      //   ]
      // ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines ?? (obscureText ? 1 : null),
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: AppColors.card,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

