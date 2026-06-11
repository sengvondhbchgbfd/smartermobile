import 'package:flutter/material.dart';
import 'app_pallets.dart';
import 'app_colors.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1.5),
    borderRadius: BorderRadius.circular(12),
  );
  ////////////////////////////////////////////////////////
  ////
  ///////////////////////////////////////////////////////
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkScheme,
    scaffoldBackgroundColor: Pallets.backgroundDark,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(Pallets.borderDark),
      focusedBorder: _border(Pallets.gradient2),
      hintStyle: const TextStyle(color: Pallets.textSecondaryDark),
    ),
    ////////////////////////////////////////////////////////
    ////
    ///////////////////////////////////////////////////////
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallets.backgroundDark,
      selectedItemColor: Pallets.gradient2,
      unselectedItemColor: Pallets.inactive,
    ),

    ////////////////////////////////////////////////////////
    ////
    ///////////////////////////////////////////////////////
    cardTheme: CardThemeData(
      color: Pallets.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Pallets.borderDark),
      ),
    ),
    ////////////////////////////////////////////////////////
    ////
    ///////////////////////////////////////////////////////
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallets.gradient2,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
  ////////////////////////////////////////////////////////
  ////
  ///////////////////////////////////////////////////////

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightScheme,
    scaffoldBackgroundColor: Pallets.backgroundLight,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(Pallets.borderLight),
      focusedBorder: _border(Pallets.gradient2),
      hintStyle: const TextStyle(color: Pallets.textSecondaryLight),
    ),

    ////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallets.surfaceLight,
      selectedItemColor: Pallets.gradient2,
      unselectedItemColor: Pallets.inactive,
    ),

    /////////////////////////////////////////////////////
    ///
    /////////////////////////////////////////////////////
    cardTheme: CardThemeData(
      color: Pallets.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Pallets.borderLight),
      ),
    ),

    ////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallets.gradient2,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}


