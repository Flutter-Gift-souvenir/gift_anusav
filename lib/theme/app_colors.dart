import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevent instantiation

  // --- Primary Brand Colors ---
  static const Color primary = Color(0xFFB5451B);       // Khmer red-orange
  static const Color primaryLight = Color(0xFFE8723A);
  static const Color primaryDark = Color(0xFF7A2D0E);

  // --- Secondary / Accent ---
  static const Color gold = Color(0xFFD4A853);           // Cambodian gold
  static const Color goldLight = Color(0xFFF0CC7A);
  static const Color goldDark = Color(0xFF9A7530);

  // --- Neutrals ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // --- Semantic Colors ---
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF1E88E5);

  // --- Background ---
  static const Color backgroundLight = Color(0xFFFFFBF7); // warm white
  static const Color backgroundDark = Color(0xFF1A1208);  // deep warm dark

  // --- Surface ---
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C1F0E);

  // --- Text ---
  static const Color textPrimaryLight = Color(0xFF1A1208);
  static const Color textSecondaryLight = Color(0xFF6B5B45);
  static const Color textPrimaryDark = Color(0xFFFFF8F0);
  static const Color textSecondaryDark = Color(0xFFBFAA8E);
}