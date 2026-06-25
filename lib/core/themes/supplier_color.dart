import 'package:flutter/material.dart';

class SupplierColors {
  final bool isDark;
  SupplierColors._(this.isDark);

  factory SupplierColors.of(BuildContext context) {
    return SupplierColors._(Theme.of(context).brightness == Brightness.dark);
  }

  // ── Surfaces ──────────────────────────────────────────────────────────
  Color get background => isDark ? const Color(0xFF141414) : const Color(0xFFFAFAF8);
  Color get surface => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  Color get surfaceMuted => isDark ? const Color(0xFF232321) : const Color(0xFFF2F1ED);

  // ── Borders / dividers ───────────────────────────────────────────────
  Color get border => isDark ? const Color(0xFF2E2E2C) : const Color(0xFFE5E3DD);

  // ── Text ──────────────────────────────────────────────────────────────
  Color get textPrimary => isDark ? const Color(0xFFF2F2F0) : const Color(0xFF1C1C1E);
  Color get textSecondary => isDark ? const Color(0xFF9B9B97) : const Color(0xFF6B6B68);
  Color get textTertiary => isDark ? const Color(0xFF6E6E6B) : const Color(0xFFA8A6A0);

  // ── Accent (signature) ───────────────────────────────────────────────
  Color get accent => isDark ? const Color(0xFF3DD9B8) : const Color(0xFF0F6E5E);
  Color get accentMuted => isDark ? const Color(0xFF1F3833) : const Color(0xFFE3F1ED);
  Color get onAccent => isDark ? const Color(0xFF0A1F1B) : const Color(0xFFFFFFFF);

  // ── Status ────────────────────────────────────────────────────────────
  Color get danger => isDark ? const Color(0xFFFF8A80) : const Color(0xFFB3261E);
  Color get dangerMuted => isDark ? const Color(0xFF3A2220) : const Color(0xFFFBEAE8);
}