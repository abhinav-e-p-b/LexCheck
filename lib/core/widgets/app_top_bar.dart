import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// Top bar used on Home / LexChat / Resources / Profile screens.
/// Light mode: "☰  LEXCHECK  (?)"
/// Dark mode:  "⌗ LEGAL_CORE_v1.0  🛡"
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, this.onMenuTap, this.onHelpTap, this.showBackButton = false});

  final VoidCallback? onMenuTap;
  final VoidCallback? onHelpTap;
  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: style.scaffoldBackground,
        border: Border(bottom: BorderSide(color: style.borderColor, width: 1.4)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: showBackButton ? () => Navigator.of(context).pop() : onMenuTap,
            child: Icon(
              showBackButton
                  ? (isDark ? Icons.arrow_back_ios : Icons.arrow_back)
                  : (isDark ? Icons.terminal : Icons.menu),
              color: style.inkColor,
              size: 22,
            ),
          ),
          const Spacer(),
          Text(
            isDark ? 'LEGAL_CORE_v1.0' : 'LEXCHECK',
            style: TextStyle(
              color: isDark ? style.accentColor : style.inkColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onHelpTap,
            child: Icon(
              isDark ? Icons.shield_outlined : Icons.help_outline,
              color: isDark ? style.accentColor : style.inkColor,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
