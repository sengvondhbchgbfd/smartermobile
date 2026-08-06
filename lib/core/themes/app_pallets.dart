import 'package:flutter/material.dart';

class Pallets {
  // ── Brand ─────────────────────────────────────────────
  static const Color blurple = Color(0xFF7C6FF7);
  static const Color blurpleDim = Color(0xFF5A52D5);
  static const Color purpleStart = Color(0xFF6D28D9);
  static const Color purpleEnd = Color(0xFF4338CA);

  // Gradient aliases (keeps existing code working)
  static const Color gradient1 = Color(0xFF6D28D9);
  static const Color gradient2 = Color(0xFF7C6FF7);
  static const Color gradient3 = Color(0xFF4338CA);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleStart, blurple, purpleEnd],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleStart, purpleEnd],
  );

  // ── Backgrounds ───────────────────────────────────────
  // Deep navy feel — not pure black, not grey, but cool-toned dark
  static const Color backgroundDark = Color(0xFF0D1117); // deepest navy-black
  static const Color backgroundLight = Color(0xFFF0F2F5);
  static const Color surfaceDark = Color(0xFF161B27); // main scaffold dark
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // ── Card / elevated surfaces ──────────────────────────
  static const Color surfaceCard = Color(0xFF1C2333); // cards — navy slate
  static const Color surfaceElevated = Color(
    0xFF212840,
  ); // FAB, inputs — slightly purple-tinted
  static const Color surfaceOverlay = Color(0xFF1A2035); // bottom sheets

  // ── Borders ───────────────────────────────────────────
  static const Color borderDark = Color(0xFF2A3350); // navy-tinted border
  static const Color borderLight = Color(0xFFE0E4EF);

  // ── Text ──────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFE8ECF4); // crisp white-blue
  static const Color textPrimaryLight = Color(0xFF0F1117);
  static const Color textSecondaryDark = Color(0xFF8892B0); // slate-blue muted
  static const Color textSecondaryLight = Color(0xFF5A6480);
  static const Color textMuted = Color(0xFF64748B); // slate-500

  // ── Semantic ──────────────────────────────────────────
  static const Color error = Color(0xFFF87171); // softer red on dark
  static const Color success = Color(0xFF34D399); // emerald green
  static const Color warning = Color(0xFFFBBF24); // amber
  static const Color info = Color(0xFF7C6FF7); // same as blurple
  static const Color inactive = Color(0xFF64748B);

  // ── Semantic tints ────────────────────────────────────
  static const Color errorTint = Color(0x26F87171);
  static const Color successTint = Color(0x2634D399);
  static const Color warningTint = Color(0x26FBBF24);
  static const Color infoTint = Color(0x267C6FF7);

  // ── Overlays ──────────────────────────────────────────
  static const Color scrim = Color(0x99000000); // slightly heavier scrim
  static const Color transparent = Colors.transparent;
  static const Color inactiveSeek = Colors.white24;

  // ── Divider ───────────────────────────────────────────
  static const Color dividerDark = Color(0xFF1E2A42);
  static const Color dividerLight = Color(0xFFE4E8F0);

  // ── On-color ──────────────────────────────────────────
  static const Color onAccent = Color(0xFFFFFFFF);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onSuccess = Color(0xFF0F1117);
  static const Color onWarning = Color(0xFF0F1117);
}
