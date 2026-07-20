import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// A card that renders as a hard-edged, offset-shadow "brutalist" box in
/// light mode, or a soft rounded glowing-border "terminal" panel in dark
/// mode. All screens should build their cards from this widget so both
/// modes stay visually consistent with the two screenshot sets.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.alt = false,
    this.borderColor,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool alt;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final bg = alt ? style.cardBackgroundAlt : style.cardBackground;
    final border = borderColor ?? style.borderColor;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(style.cardRadius),
        border: Border.all(color: border, width: style.borderWidth),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            offset: style.shadowOffset,
            blurRadius: style.shadowBlur,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
