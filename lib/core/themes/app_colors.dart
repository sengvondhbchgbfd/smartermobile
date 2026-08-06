import 'package:flutter/material.dart';
import 'app_pallets.dart';

class AppColors {
  static ColorScheme get darkScheme => const ColorScheme.dark(
    primary: Pallets.blurple,
    primaryContainer: Color.fromRGBO(90, 82, 213, 1),
    secondary: Pallets.purpleStart,
    surface: Pallets.surfaceDark,
    surfaceContainer: Pallets.surfaceCard,
    error: Pallets.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Pallets.textPrimaryDark,
    onError: Colors.white,
    outline: Pallets.borderDark,
  );

  static ColorScheme get lightScheme => const ColorScheme.light(
    primary: Pallets.blurple,
    primaryContainer: Pallets.blurpleDim,
    secondary: Pallets.purpleStart,
    surface: Pallets.surfaceLight,
    surfaceContainer: Color(0xFFF2F3F5),
    error: Pallets.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Pallets.textPrimaryLight,
    onError: Colors.white,
    outline: Pallets.borderLight,
  );
}


