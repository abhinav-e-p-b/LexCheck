import 'package:flutter/material.dart';

/// Centralised colour tokens for the two LexCheck visual modes:
/// - Light ("LEXCHECK" cream/orange brutalist look)
/// - Dark ("LEGAL_CORE_v1.0" navy/orange terminal look)
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // LIGHT THEME ("LEXCHECK" brutalist)
  // ---------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFFBF0E6);
  static const Color lightSurface = Color(0xFFFDF8F3);
  static const Color lightSurfaceAlt = Color(0xFFF7E4CE);
  static const Color lightBorder = Color(0xFF1B140F);
  static const Color lightInk = Color(0xFF1B140F);
  static const Color lightInkMuted = Color(0xFF8A7F74);
  static const Color lightOrange = Color(0xFFDE8A3B);
  static const Color lightOrangeDark = Color(0xFF9C5A21);
  static const Color lightShadow = Color(0xFF1B140F);
  static const Color lightHighRiskBg = Color(0xFFB23A2E);
  static const Color lightUpdateBg = Color(0xFF7A4A26);
  static const Color lightDivider = Color(0x331B140F);

  // ---------------------------------------------------------------------
  // DARK THEME ("LEGAL_CORE_v1.0" terminal)
  // ---------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF141C30);
  static const Color darkSurfaceAlt = Color(0xFF1A2338);
  static const Color darkBorder = Color(0xFFE9944A);
  static const Color darkBorderMuted = Color(0xFF2B3550);
  static const Color darkInk = Color(0xFFE7EAF5);
  static const Color darkInkMuted = Color(0xFF6E7A97);
  static const Color darkOrange = Color(0xFFF0A050);
  static const Color darkShadow = Color(0xFF000000);
  static const Color darkCritical = Color(0xFFC0392B);
  static const Color darkModerate = Color(0xFFE08A3A);
  static const Color darkGaugeLow = Color(0xFF3E6B4F);
  static const Color darkGaugeMid = Color(0xFF8A5A2A);
  static const Color darkGaugeHigh = Color(0xFF8C2C22);

  // Shared
  static const Color success = Color(0xFF3E6B4F);
  static const Color danger = Color(0xFFB23A2E);
}
