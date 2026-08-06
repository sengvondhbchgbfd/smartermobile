import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class _PaletteData {
  final Color background;
  final Color surface;
  final Color fillColor;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color dialogBg;

  const _PaletteData({
    required this.background,
    required this.surface,
    required this.fillColor,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.dialogBg,
  });
}

class Palette {
  Palette._();

  static _PaletteData of(bool isDark) => isDark ? _dark : _light;

  static const _dark = _PaletteData(
    background: Pallets.backgroundDark,
    surface: Pallets.surfaceDark,
    fillColor: Pallets.surfaceElevated,
    border: Pallets.borderDark,
    textPrimary: Pallets.textPrimaryDark,
    textSecondary: Pallets.textSecondaryDark,
    dialogBg: Pallets.surfaceCard,
  );

  static const _light = _PaletteData(
    background: Pallets.backgroundLight,
    surface: Pallets.surfaceLight,
    fillColor: Pallets.backgroundLight,
    border: Pallets.borderLight,
    textPrimary: Pallets.textPrimaryLight,
    textSecondary: Pallets.textSecondaryLight,
    dialogBg: Pallets.surfaceLight,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// PaletteScreen — used in NotificationScreen
// ─────────────────────────────────────────────────────────────────────────────
class _PaletteScreenData {
  final Color bg;
  final Color card;
  final Color text;
  final Color subText;
  final Color accent;
  final Color border;

  const _PaletteScreenData({
    required this.bg,
    required this.card,
    required this.text,
    required this.subText,
    required this.accent,
    required this.border,
  });
}

class PaletteScreen {
  PaletteScreen._();

  static _PaletteScreenData of(bool isDark) => isDark ? _dark : _light;

  static const _dark = _PaletteScreenData(
    bg: Pallets.backgroundDark,
    card: Pallets.surfaceDark,
    text: Pallets.textPrimaryDark,
    subText: Pallets.textSecondaryDark,
    accent: Pallets.gradient2,
    border: Pallets.borderDark,
  );

  static const _light = _PaletteScreenData(
    bg: Pallets.backgroundLight,
    card: Pallets.surfaceLight,
    text: Pallets.textPrimaryLight,
    subText: Pallets.textSecondaryLight,
    accent: Pallets.gradient2,
    border: Pallets.borderLight,
  );
}
