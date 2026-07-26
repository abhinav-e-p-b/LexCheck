import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/mock_providers.dart';
import '../../core/theme/app_style.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../onboarding/welcome_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = context.appStyle;
    final theme = ref.watch(themeProvider);
    final isDark = theme == ThemeMode.dark;
    final settings = ref.watch(profileSettingsProvider);
    final settingsNotifier = ref.read(profileSettingsProvider.notifier);

    return Scaffold(
      appBar: const AppTopBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: style.cardBackgroundAlt,
                          border: Border.all(
                              color: style.borderColor, width: style.borderWidth),
                        ),
                        child: Icon(Icons.face_outlined,
                            size: 40, color: style.inkColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('LEGAL ASSOCIATE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          color: isDark
                                              ? style.accentColor
                                              : style.inkColor)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  color: style.accentColor,
                                  child: const Text('LVL 42',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87)),
                                ),
                              ],
                            ),
                            Text('ID: LX-83KD92',
                                style: TextStyle(
                                    fontSize: 12, color: style.inkMutedColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (isDark) ...[
                    _KeyValueRow(label: 'CLEARANCE:', value: 'LEVEL-4', style: style),
                    const SizedBox(height: 6),
                    _KeyValueRow(label: 'REGION:', value: 'EU-NORTH-1', style: style),
                  ] else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('STATUS',
                            style: TextStyle(
                                fontSize: 11, color: style.inkMutedColor)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: style.borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 6),
                              Text('ONLINE',
                                  style: TextStyle(
                                      fontSize: 11, color: style.inkColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!isDark)
              const Row(
                children: [
                  Expanded(
                    child: _StatBox(
                        label: 'CASE VELOCITY', value: '94.2%'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                        label: 'COMPLIANCE RATE', value: 'SIGMA-9'),
                  ),
                ],
              )
            else ...[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Case Velocity',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: style.inkColor)),
                        Icon(Icons.bolt, size: 16, color: style.accentColor),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('94.2%',
                        style: TextStyle(
                            color: style.accentColor,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.942,
                        minHeight: 6,
                        backgroundColor: style.borderColor.withValues(alpha: 0.25),
                        valueColor:
                            AlwaysStoppedAnimation(style.accentColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Compliance Rate',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: style.inkColor)),
                    Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            size: 16, color: style.accentColor),
                        const SizedBox(width: 6),
                        Text('Sigma-9',
                            style: TextStyle(color: style.inkMutedColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                borderColor: style.accentColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history, size: 14, color: style.accentColor),
                        const SizedBox(width: 6),
                        Text('ACTIVE_SESSION_LOG',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: style.accentColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '> [14:22] ACCESSING LEXCHAT_CORE_ENCRYPTION...\n'
                      '> [14:23] CASE_822-J FILED SUCCESSFULLY.\n'
                      '> [15:01] DATA_BUFFER_70%_FULL. RECOMMEND_CLEARANCE.',
                      style: TextStyle(
                          fontSize: 11, color: style.inkMutedColor, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text('APP PREFERENCES',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: style.inkMutedColor)),
            const SizedBox(height: 10),
            _PrefTile(
              icon: Icons.nightlight_round,
              title: 'Terminal Night Mode',
              subtitle: isDark
                  ? 'High contrast dark environment'
                  : 'Invert interface for low-light sessions',
              value: isDark,
              onChanged: ref.read(themeProvider.notifier).toggle,
            ),
            const SizedBox(height: 12),
            _PrefTile(
              icon: Icons.volume_up_outlined,
              title: 'Mechanical Feedback',
              subtitle: isDark
                  ? 'Audio triggers on interaction'
                  : 'Enable tactile audio cues on click',
              value: settings.mechanicalFeedback,
              onChanged: settingsNotifier.toggleMechanicalFeedback,
            ),
            const SizedBox(height: 12),
            _PrefTile(
              icon: Icons.crop_din,
              title: 'Haptic Overlays',
              subtitle: isDark
                  ? 'Tactile UI simulation'
                  : 'Enhanced visual response patterns',
              value: settings.hapticOverlays,
              onChanged: settingsNotifier.toggleHapticOverlays,
            ),
            if (isDark) ...[
              const SizedBox(height: 12),
              _PrefTile(
                icon: Icons.archive_outlined,
                title: 'Auto-Archive Buffer',
                subtitle: 'Preserve session logs locally',
                value: settings.autoArchive,
                onChanged: settingsNotifier.toggleAutoArchive,
              ),
            ],
            const SizedBox(height: 20),
            Text('PRIVACY & DATA',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: style.inkMutedColor)),
            const SizedBox(height: 10),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ActionRow(
                    icon: Icons.shield_outlined,
                    title: 'Clear Activity Buffer',
                    trailing: Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Activity buffer cleared'), backgroundColor: style.accentColor),
                      );
                    },
                  ),
                  Divider(height: 1, color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.vpn_key_outlined,
                    title: 'Terminal Encryption Keys',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      color: style.inkColor,
                      child: Text('SECURE',
                          style: TextStyle(
                              fontSize: 10,
                              color: style.scaffoldBackground,
                              fontWeight: FontWeight.w700)),
                    ),
                    onTap: () {},
                  ),
                  Divider(height: 1, color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.remove_circle_outline,
                    title: 'Decommission Profile',
                    titleColor: Colors.red.shade400,
                    trailing:
                        Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Decommission requested.'), backgroundColor: Colors.red.shade400),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: style.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(style.cardRadius),
                      side: BorderSide(color: style.borderColor, width: style.borderWidth),
                    ),
                    title: Text(
                      'TERMINATE SESSION?',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: style.inkColor,
                        fontSize: 16,
                      ),
                    ),
                    content: Text(
                      'All active session data will be cleared. You will be returned to the start screen.',
                      style: TextStyle(fontSize: 13, color: style.inkMutedColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('CANCEL',
                            style: TextStyle(color: style.inkMutedColor)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const WelcomeScreen()),
                            (route) => false,
                          );
                        },
                        child: Text('CONFIRM',
                            style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: style.inkColor.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(style.cardRadius),
                ),
                child: Center(
                  child: Text('TERMINATE SESSION',
                      style: TextStyle(
                          color: style.scaffoldBackground,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value, required this.style});
  final String label;
  final String value;
  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: style.inkMutedColor)),
        Text(value,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: style.accentColor)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 10, color: style.inkMutedColor)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: style.inkColor)),
        ],
      ),
    );
  }
}

class _PrefTile extends StatelessWidget {
  const _PrefTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Row(
        children: [
          if (!isDark)
            Container(
              width: 36,
              height: 36,
              color: style.inkColor,
              child: Icon(icon, color: style.scaffoldBackground, size: 18),
            )
          else
            Icon(icon, color: style.inkMutedColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.w700, color: style.inkColor)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 11.5, color: style.inkMutedColor)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: style.accentColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: titleColor ?? style.inkColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? style.inkColor)),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
