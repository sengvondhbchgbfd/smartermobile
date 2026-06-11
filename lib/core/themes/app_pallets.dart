import 'package:flutter/material.dart';

class Pallets {
  // Brand gradient

  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradient1,
      gradient2,
      gradient3,
    ],
  );

  // Backgrounds
  static const Color backgroundDark   = Color.fromRGBO(18, 18, 18, 1);
  static const Color backgroundLight  = Color(0xFFF5F5F5);
  static const Color surfaceDark      = Color(0xFF1E1E2E);
  static const Color surfaceLight     = Color(0xFFFFFFFF);

  // Border
  static const Color borderDark  = Color.fromRGBO(52, 51, 67, 1);
  static const Color borderLight = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimaryDark    = Color(0xFFFFFFFF);
  static const Color textPrimaryLight   = Color(0xFF121212);
  static const Color textSecondaryDark  = Color(0xFFA7A7A7);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);


  // Semantic
  static const Color error   = Colors.redAccent;
  static const Color success = Colors.green;
  static const Color inactive = Color(0xFFABABAB);
  static const Color transparent = Colors.transparent;
  static const Color inactiveSeek = Colors.white38;
}