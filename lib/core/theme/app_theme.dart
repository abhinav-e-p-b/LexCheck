import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_style.dart';

/// Builds the two Material 3 [ThemeData] objects used across the app.
/// Typography uses JetBrains Mono everywhere to match the retro terminal
/// look shown in both the light and dark screenshots.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightOrange,
        onPrimary: AppColors.lightInk,
        secondary: AppColors.lightOrangeDark,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightInk,
      ),
      fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
      textTheme: _textTheme(AppColors.lightInk),
      dividerColor: AppColors.lightDivider,
      extensions: const [AppStyle.light],
    );
    return base;
  }

  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkOrange,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.darkOrange,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkInk,
      ),
      fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
      textTheme: _textTheme(AppColors.darkInk),
      dividerColor: AppColors.darkBorderMuted,
      extensions: const [AppStyle.dark],
    );
    return base;
  }

  static TextTheme _textTheme(Color ink) {
    return GoogleFonts.jetBrainsMonoTextTheme().apply(
      bodyColor: ink,
      displayColor: ink,
    );
  }
}
