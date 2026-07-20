import 'package:flutter/material.dart';

import '../theme/app_style.dart';

class NavItemData {
  const NavItemData(this.label, this.icon);
  final String label;
  final IconData icon;
}

const List<NavItemData> kNavItems = [
  NavItemData('Home', Icons.home_outlined),
  NavItemData('LexChat', Icons.smart_toy_outlined),
  NavItemData('Resources', Icons.description_outlined),
  NavItemData('Profile', Icons.person_outline),
];

/// Bottom navigation bar reused across Home / LexChat / Resources / Profile.
/// Active tab renders as a filled highlighted pill/box in both themes,
/// matching the screenshots.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.cardBackground,
        border: Border(top: BorderSide(color: style.borderColor, width: 1.4)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(kNavItems.length, (i) {
              final item = kNavItems[i];
              final active = i == currentIndex;
              final activeBg =
                  isDark ? style.accentColor : const Color(0xFF6B3A20);
              final activeFg = isDark ? style.scaffoldBackground : Colors.white;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: active ? activeBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 20,
                            color: active ? activeFg : style.inkMutedColor,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? activeFg : style.inkMutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
