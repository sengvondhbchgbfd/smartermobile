import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

extension InvoiceThemeX on BuildContext {
  InvoiceColors get invoiceColors {
    final isDark = Theme.of(this).brightness == Brightness.dark;

    return InvoiceColors(isDark: isDark);
  }
}

class InvoiceColors {
  final bool isDark;
  InvoiceColors({required this.isDark});

  ////////////////////////
  // set Dark Color
  ///////////////////////
  Color get background =>
      isDark ? Pallets.backgroundDark : Pallets.backgroundLight;

  Color get card => isDark ? Pallets.surfaceCard : Pallets.surfaceLight;

  Color get overlay => isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight;

  Color get textPrimary =>
      isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;

  Color get textSecondary =>
      isDark ? Pallets.textSecondaryDark : Pallets.textPrimaryLight;

  Color get border => isDark ? Pallets.borderDark : Pallets.borderLight;

  Color get accent => Pallets.blurple;

  Color get onAccent => Pallets.onAccent;

  Color get error => Pallets.error;

  OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
