import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Holds the shape/border/shadow language that differs between the two
/// LexCheck modes:
/// - Light = "brutalist": square corners, thick black border, hard offset shadow.
/// - Dark = "terminal": soft rounded corners, glowing orange border, soft shadow.
class AppStyle extends ThemeExtension<AppStyle> {
  const AppStyle({
    required this.cardRadius,
    required this.borderWidth,
    required this.borderColor,
    required this.cardBackground,
    required this.cardBackgroundAlt,
    required this.shadowOffset,
    required this.shadowColor,
    required this.shadowBlur,
    required this.inkColor,
    required this.inkMutedColor,
    required this.accentColor,
    required this.scaffoldBackground,
  });

  final double cardRadius;
  final double borderWidth;
  final Color borderColor;
  final Color cardBackground;
  final Color cardBackgroundAlt;
  final Offset shadowOffset;
  final Color shadowColor;
  final double shadowBlur;
  final Color inkColor;
  final Color inkMutedColor;
  final Color accentColor;
  final Color scaffoldBackground;

  static const AppStyle light = AppStyle(
    cardRadius: 0,
    borderWidth: 2,
    borderColor: AppColors.lightBorder,
    cardBackground: AppColors.lightSurface,
    cardBackgroundAlt: AppColors.lightSurfaceAlt,
    shadowOffset: Offset(6, 6),
    shadowColor: AppColors.lightShadow,
    shadowBlur: 0,
    inkColor: AppColors.lightInk,
    inkMutedColor: AppColors.lightInkMuted,
    accentColor: AppColors.lightOrange,
    scaffoldBackground: AppColors.lightBackground,
  );

  static const AppStyle dark = AppStyle(
    cardRadius: 10,
    borderWidth: 1.4,
    borderColor: AppColors.darkBorderMuted,
    cardBackground: AppColors.darkSurface,
    cardBackgroundAlt: AppColors.darkSurfaceAlt,
    shadowOffset: Offset(0, 4),
    shadowColor: Colors.black54,
    shadowBlur: 12,
    inkColor: AppColors.darkInk,
    inkMutedColor: AppColors.darkInkMuted,
    accentColor: AppColors.darkOrange,
    scaffoldBackground: AppColors.darkBackground,
  );

  @override
  AppStyle copyWith({
    double? cardRadius,
    double? borderWidth,
    Color? borderColor,
    Color? cardBackground,
    Color? cardBackgroundAlt,
    Offset? shadowOffset,
    Color? shadowColor,
    double? shadowBlur,
    Color? inkColor,
    Color? inkMutedColor,
    Color? accentColor,
    Color? scaffoldBackground,
  }) {
    return AppStyle(
      cardRadius: cardRadius ?? this.cardRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundAlt: cardBackgroundAlt ?? this.cardBackgroundAlt,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      inkColor: inkColor ?? this.inkColor,
      inkMutedColor: inkMutedColor ?? this.inkMutedColor,
      accentColor: accentColor ?? this.accentColor,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
    );
  }

  @override
  ThemeExtension<AppStyle> lerp(ThemeExtension<AppStyle>? other, double t) {
    // Modes are switched discretely (not animated blends), so just snap.
    if (other is! AppStyle) return this;
    return t < 0.5 ? this : other;
  }
}

/// Convenience accessor: `context.appStyle`
extension AppStyleContext on BuildContext {
  AppStyle get appStyle => Theme.of(this).extension<AppStyle>()!;
}
