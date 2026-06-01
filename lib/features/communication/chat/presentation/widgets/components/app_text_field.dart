import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.autofocus = false,
    this.keyboardType,
    this.onSubmitted,
    this.contentPadding,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool autofocus;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: Color(0xFFe8eaed),
        fontSize: 14.5,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF8a9bb0),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: const Color(0xFF8a9bb0),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF17212b),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF1f3040)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF1f3040)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF3a7bd5)),
        ),
      ),
    );
  }
}