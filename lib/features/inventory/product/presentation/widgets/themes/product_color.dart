import 'package:flutter/material.dart';

class ProductColor {
  static Color card(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF2C2C2E)
      : Colors.white;

  static Color border(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF3A3A3C)
      : const Color(0xFFE0DED8);

  static Color searchBg(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF3A3A3C)
      : const Color(0xFFEFEFED);

  static Color sub(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
      ? const Color(0xFF8E8E93)
      : const Color(0xFF6B6B6B);
}