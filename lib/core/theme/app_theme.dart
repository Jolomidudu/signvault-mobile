import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF176B55);
  static const primaryDark = Color(0xFF104A3D);
  static const accent = Color(0xFFC7A66A);
  static const canvas = Color(0xFFF5F7F5);
  static const surface = Colors.white;
  static const text = Color(0xFF17251F);
  static const muted = Color(0xFF69766F);
  static const border = Color(0xFFE1E8E3);
  static const success = Color(0xFF287A56);
  static const error = Color(0xFFB4473E);
  static const warning = Color(0xFF9B702A);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class AppRadius {
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 22.0;
}

abstract final class AppTypography {
  static const title = TextStyle(
    fontSize: 30,
    height: 1.12,
    fontWeight: FontWeight.w700,
  );
  static const heading = TextStyle(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );
  static const body = TextStyle(fontSize: 15, height: 1.5);
  static const caption = TextStyle(fontSize: 13, height: 1.4);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
      error: AppColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }
}
