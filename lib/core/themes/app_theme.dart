import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_pallets.dart';
import 'app_colors.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1.5),
    borderRadius: BorderRadius.circular(12),
  );

  // ────────────────────────────────────────────────────
  // DARK
  // ────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkScheme,
    scaffoldBackgroundColor: Pallets.surfaceDark,

    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallets.surfaceDark,
      foregroundColor: Pallets.textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Pallets.surfaceElevated,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(Pallets.borderDark),
      focusedBorder: _border(Pallets.blurple),
      errorBorder: _border(Pallets.error),
      focusedErrorBorder: _border(Pallets.error),
      hintStyle: const TextStyle(color: Pallets.textMuted),
    ),

    // Bottom nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallets.backgroundDark,
      selectedItemColor: Pallets.blurple,
      unselectedItemColor: Pallets.textMuted,
      elevation: 0,
    ),

    // Card
    cardTheme: CardThemeData(
      color: Pallets.surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Pallets.borderDark),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Pallets.borderDark,
      thickness: 1,
      space: 1,
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallets.blurple,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Pallets.blurple),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: Pallets.surfaceCard,
      selectedColor: Pallets.blurple,
      labelStyle: const TextStyle(color: Pallets.textPrimaryDark, fontSize: 13),
      side: const BorderSide(color: Pallets.borderDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: Pallets.textSecondaryDark,
      textColor: Pallets.textPrimaryDark,
    ),

    // Icon
    iconTheme: const IconThemeData(color: Pallets.textSecondaryDark, size: 22),

    // Text
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Pallets.textPrimaryDark,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: Pallets.textPrimaryDark,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Pallets.textPrimaryDark),
      bodyMedium: TextStyle(color: Pallets.textSecondaryDark),
      bodySmall: TextStyle(color: Pallets.textMuted, fontSize: 12),
      labelLarge: TextStyle(
        color: Pallets.textPrimaryDark,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // ────────────────────────────────────────────────────
  // LIGHT
  // ────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightScheme,
    scaffoldBackgroundColor: Pallets.backgroundLight,

    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallets.surfaceLight,
      foregroundColor: Pallets.textPrimaryLight,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F3F5),
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(Pallets.borderLight),
      focusedBorder: _border(Pallets.blurple),
      errorBorder: _border(Pallets.error),
      focusedErrorBorder: _border(Pallets.error),
      hintStyle: const TextStyle(color: Pallets.textSecondaryLight),
    ),

    // Bottom nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallets.surfaceLight,
      selectedItemColor: Pallets.blurple,
      unselectedItemColor: Pallets.inactive,
      elevation: 0,
    ),

    // Card
    cardTheme: CardThemeData(
      color: Pallets.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Pallets.borderLight),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Pallets.borderLight,
      thickness: 1,
      space: 1,
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallets.blurple,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Pallets.blurple),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF2F3F5),
      selectedColor: Pallets.blurple,
      labelStyle: const TextStyle(
        color: Pallets.textPrimaryLight,
        fontSize: 13,
      ),
      side: const BorderSide(color: Pallets.borderLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: Pallets.textSecondaryLight,
      textColor: Pallets.textPrimaryLight,
    ),

    // Icon
    iconTheme: const IconThemeData(color: Pallets.textSecondaryLight, size: 22),

    // Text
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Pallets.textPrimaryLight,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: Pallets.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Pallets.textPrimaryLight),
      bodyMedium: TextStyle(color: Pallets.textSecondaryLight),
      bodySmall: TextStyle(color: Pallets.textSecondaryLight, fontSize: 12),
      labelLarge: TextStyle(
        color: Pallets.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
