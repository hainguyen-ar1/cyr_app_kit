import 'package:flutter/material.dart';

abstract final class AppColors {
  // Shared accents (không đổi theo theme)
  static const primary = Color(0xFF6C63FF);
  static const primaryMuted = Color(0xFF4A4580);
  static const secondary = Color(0xFF00D9FF);
  static const tertiary = Color(0xFFFF6B9D);
  static const error = Color(0xFFFF5252);
  static const success = Color(0xFF4ADE80);

  // Gradients (shared)
  static const gradientPrimary = LinearGradient(
    colors: [primary, Color(0xFF9C63FF)],
  );
  static const gradientAvatar = LinearGradient(
    colors: [primary, secondary],
  );

  // --- Dark palette ---
  static const darkBackground = Color(0xFF0D0D0F);
  static const darkSurface = Color(0xFF1A1A2E);
  static const darkSurfaceVariant = Color(0xFF16213E);
  static const darkSurfaceBright = Color(0xFF222244);
  static const darkTextPrimary = Color(0xFFF0F0F5);
  static const darkTextSecondary = Color(0xFF9898B0);
  static const darkTextMuted = Color(0xFF5E5E78);
  static const darkBorder = Color(0xFF2A2A42);
  static const darkDivider = Color(0xFF222240);

  static const darkGradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkSurfaceVariant, darkBackground],
  );

  // --- Light palette ---
  static const lightBackground = Color(0xFFF5F5FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFEEEEF5);
  static const lightSurfaceBright = Color(0xFFE8E8F0);
  static const lightTextPrimary = Color(0xFF1A1A2E);
  static const lightTextSecondary = Color(0xFF6B6B80);
  static const lightTextMuted = Color(0xFF9898B0);
  static const lightBorder = Color(0xFFDDDDE5);
  static const lightDivider = Color(0xFFEEEEF2);

  static const lightGradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightSurfaceVariant, lightBackground],
  );
}