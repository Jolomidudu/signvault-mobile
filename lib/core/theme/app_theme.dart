import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF0F172A);
  static const primaryDark = Color(0xFF0F172A);
  static const accent = Color(0xFF2563EB);
  static const accentSoft = Color(0xFFEFF6FF);
  static const successSoft = Color(0xFFECFDF5);
  static const surfaceMuted = Color(0xFFF1F5F9);
  static const progressTrack = Color(0xFF334155);
  static const canvas = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const success = Color(0xFF047857);
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
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.surface,
          error: AppColors.error,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.accent,
          onSecondary: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.text,
          outline: AppColors.border,
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
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
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
        style: TextButton.styleFrom(foregroundColor: AppColors.accent),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }
}
