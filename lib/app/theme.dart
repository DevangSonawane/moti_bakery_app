import 'package:flutter/material.dart';

class AppColors {
  static const brandOrange = Color(0xFFD94F1E);
  static const accentOrange = Color(0xFFF28B5B);
  static const darkCharcoal = Color(0xFF2B2B2B);
  static const lightCream = Color(0xFFFFF5F2);
  static const midGrey = Color(0xFF7A7A7A);
  static const successGreen = Color(0xFF4CAF50);
  static const infoBlue = Color(0xFF2196F3);
  static const neutralGrey = Color(0xFF9E9E9E);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.brandOrange,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.brandOrange,
    secondary: AppColors.accentOrange,
    surface: Colors.white,
    onSurface: AppColors.darkCharcoal,
    onPrimary: Colors.white,
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.lightCream,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.darkCharcoal,
      centerTitle: false,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDADADA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDADADA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.brandOrange, width: 1.2),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    chipTheme: const ChipThemeData(
      selectedColor: AppColors.brandOrange,
      labelStyle: TextStyle(color: AppColors.darkCharcoal),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      side: BorderSide.none,
    ),
    useMaterial3: true,
  );
}
