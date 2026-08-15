import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightDivider,
      primaryContainer: AppColors.lightSurfaceBright,
      onPrimaryContainer: AppColors.lightTextPrimary,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ).apply(
      bodyColor: AppColors.lightTextPrimary,
      displayColor: AppColors.lightTextPrimary,
    );

    return _buildTheme(
      base: ThemeData.light(useMaterial3: true),
      scheme: scheme,
      textTheme: textTheme,
      scaffoldBg: AppColors.lightBackground,
      surfaceColor: AppColors.lightSurface,
      borderColor: AppColors.lightBorder,
      dividerColor: AppColors.lightDivider,
      textSecondary: AppColors.lightTextSecondary,
      textMuted: AppColors.lightTextMuted,
      textPrimary: AppColors.lightTextPrimary,
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      tertiary: AppColors.tertiary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkDivider,
      primaryContainer: AppColors.darkSurfaceBright,
      onPrimaryContainer: AppColors.darkTextPrimary,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    );

    return _buildTheme(
      base: ThemeData.dark(useMaterial3: true),
      scheme: scheme,
      textTheme: textTheme,
      scaffoldBg: AppColors.darkBackground,
      surfaceColor: AppColors.darkSurface,
      borderColor: AppColors.darkBorder,
      dividerColor: AppColors.darkDivider,
      textSecondary: AppColors.darkTextSecondary,
      textMuted: AppColors.darkTextMuted,
      textPrimary: AppColors.darkTextPrimary,
    );
  }

  static ThemeData _buildTheme({
    required ThemeData base,
    required ColorScheme scheme,
    required TextTheme textTheme,
    required Color scaffoldBg,
    required Color surfaceColor,
    required Color borderColor,
    required Color dividerColor,
    required Color textSecondary,
    required Color textMuted,
    required Color textPrimary,
  }) {
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: textTheme,
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
        space: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: borderColor, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textMuted),
        prefixIconColor: textSecondary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: borderColor),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
      iconTheme: IconThemeData(color: textSecondary, size: 20),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}