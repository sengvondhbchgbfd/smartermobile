import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LeavePalette — drop-in theme token bag for all Leave screens & widgets
// Usage:  final p = LeavePalette.of(isDark);
// ─────────────────────────────────────────────────────────────────────────────
class LeavePalette {
  const LeavePalette._({
    required this.bg,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.cancelBg,
    required this.cancelBorder,
    required this.cancelText,
  });

  final Color bg;
  final Color card;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;

  // ── Cancel button tints ───────────────────────────────────────────────────
  final Color cancelBg;
  final Color cancelBorder;
  final Color cancelText;

  static LeavePalette of(bool isDark) => isDark ? _dark : _light;

  static final _dark = LeavePalette._(
    bg: Pallets.backgroundDark,
    card: Pallets.surfaceDark,
    border: Pallets.borderDark,
    textPrimary: Pallets.textPrimaryDark,
    textSecondary: Pallets.textSecondaryDark,
    accent: Pallets.gradient2,
    cancelBg: Pallets.warningTint,
    cancelBorder: Pallets.warning.withValues(alpha: 0.3),
    cancelText: Pallets.warning,
  );

  static final _light = LeavePalette._(
    bg: Pallets.backgroundLight,
    card: Pallets.surfaceLight,
    border: Pallets.borderLight,
    textPrimary: Pallets.textPrimaryLight,
    textSecondary: Pallets.textSecondaryLight,
    accent: Pallets.gradient2,
    cancelBg: Pallets.warningTint,
    cancelBorder: Pallets.warning.withValues(alpha: 0.3),
    cancelText: Pallets.warning,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// LeaveTypeColor — maps LeaveType → brand color (sourced from Pallets)
// ─────────────────────────────────────────────────────────────────────────────
class LeaveTypeColor {
  LeaveTypeColor._();

  static Color of(LeaveType type) {
    return switch (type) {
      LeaveType.sick => Pallets.gradient1, // purple
      LeaveType.annual => Pallets.info, // blurple/blue
      LeaveType.unpaid => Pallets.warning, // amber
      LeaveType.other => Pallets.inactive, // muted gray
    };
  }
}
