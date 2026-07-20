import 'package:flutter/material.dart';

import '../theme/app_style.dart';

enum AppButtonVariant { primary, secondary, dark }

/// Full-width rectangular/rounded button matching the mock's chunky CTA
/// buttons ("START ANONYMOUSLY", "EXECUTE LOGIN", "CONTINUE", ...).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;

    late final Color bg;
    late final Color fg;
    late final Color border;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = style.accentColor;
        fg = style.inkColor;
        border = style.borderColor;
        break;
      case AppButtonVariant.secondary:
        bg = style.cardBackground;
        fg = style.inkColor;
        border = style.borderColor;
        break;
      case AppButtonVariant.dark:
        bg = style.inkColor.withValues(alpha: 0.92);
        fg = style.scaffoldBackground;
        border = style.inkColor;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(style.cardRadius),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: dense ? 12 : 18,
            horizontal: 16,
          ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontSize: dense ? 13 : 15,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 18, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
