import 'package:flutter/material.dart';
import 'app_pallets.dart';

class AppColors {
  static ColorScheme get darkScheme => const ColorScheme.dark(
    primary:    Pallets.gradient2,
    secondary:  Pallets.gradient1,
    surface:    Pallets.surfaceDark,
    error:      Pallets.error,
    onPrimary:  Pallets.textPrimaryDark,
    onSurface:  Pallets.textPrimaryDark,
  );

  static ColorScheme get lightScheme => const ColorScheme.light(
    primary:    Pallets.gradient2,
    secondary:  Pallets.gradient1,
    surface:    Pallets.surfaceLight,
    error:      Pallets.error,
    onPrimary:  Pallets.textPrimaryDark,
    onSurface:  Pallets.textPrimaryLight,
  );
}