import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/mock_providers.dart';
import '../../core/theme/app_style.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';

// ─── Constants (easy to update) ───────────────────────────────────────────────

const _kSupportEmail = 'support@lexcheck.app';
const _kPrivacyUrl = 'https://lexcheck.app/privacy';
const _kTermsUrl = 'https://lexcheck.app/terms';
const _kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=app.lexcheck';

// ─── Screen ───────────────────────────────────────────────────────────────────

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
            // ── APP SETTINGS ───────────────────────────────────────────────
            _SectionHeading(title: 'APP SETTINGS', style: style),
            const SizedBox(height: 10),
            _PrefTile(
              icon: Icons.nightlight_round,
              title: 'Dark Mode',
              subtitle: isDark
                  ? 'High-contrast terminal environment active'
                  : 'Switch to high-contrast terminal mode',
              value: isDark,
              onChanged: ref.read(themeProvider.notifier).toggle,
              style: style,
              isDark: isDark,
            ),
            const SizedBox(height: 24),

            // ── ABOUT ──────────────────────────────────────────────────────
            _SectionHeading(title: 'ABOUT', style: style),
            const SizedBox(height: 10),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ActionRow(
                    icon: Icons.info_outline,
                    title: 'About LexCheck',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _showAboutDialog(context, style),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.tag,
                    title: 'App Version',
                    trailing: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (ctx, snap) {
                        final version = snap.hasData
                            ? '${snap.data!.version}+${snap.data!.buildNumber}'
                            : '...';
                        return Text(
                          version,
                          style: TextStyle(
                              fontSize: 12, color: style.inkMutedColor),
                        );
                      },
                    ),
                    onTap: null,
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _launchUrl(context, _kPrivacyUrl, style),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _launchUrl(context, _kTermsUrl, style),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.balance_outlined,
                    title: 'Open Source Licenses',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () async {
                      final info = await PackageInfo.fromPlatform();
                      if (context.mounted) {
                        showLicensePage(
                          context: context,
                          applicationName: 'LexCheck',
                          applicationVersion: info.version,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── SUPPORT ────────────────────────────────────────────────────
            _SectionHeading(title: 'SUPPORT', style: style),
            const SizedBox(height: 10),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ActionRow(
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact Support',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _launchEmail(
                        context, _kSupportEmail, 'Support Request', style),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.feedback_outlined,
                    title: 'Send Feedback',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _launchEmail(
                        context, _kSupportEmail, 'App Feedback', style),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.bug_report_outlined,
                    title: 'Report a Bug',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _launchEmail(
                        context, _kSupportEmail, 'Bug Report', style),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () => _shareApp(),
                  ),
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
                  _ActionRow(
                    icon: Icons.star_outline,
                    title: 'Rate App',
                    trailing:
                        Icon(Icons.chevron_right, color: style.inkMutedColor),
                    onTap: () =>
                        _launchUrl(context, _kPlayStoreUrl, style),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── LEGAL INFORMATION ──────────────────────────────────────────
            _SectionHeading(title: 'LEGAL INFORMATION', style: style),
            const SizedBox(height: 10),
            AppCard(
              borderColor: style.accentColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16, color: style.accentColor),
                      const SizedBox(width: 8),
                      Text(
                        'EMERGENCY DISCLAIMER',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: style.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'LexCheck provides legal awareness and educational guidance '
                    'only. It is not a substitute for emergency services, police '
                    'assistance, legal representation or professional legal advice. '
                    'In any life-threatening situation, always contact emergency '
                    'services (112) immediately.',
                    style: TextStyle(
                        fontSize: 12.5,
                        color: style.inkMutedColor,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  void _showAboutDialog(BuildContext context, AppStyle style) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: style.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.cardRadius),
          side: BorderSide(color: style.borderColor, width: style.borderWidth),
        ),
        title: Text(
          'ABOUT LEXCHECK',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: style.inkColor,
              fontSize: 16),
        ),
        content: Text(
          'LexCheck is a legal awareness and emergency resource companion '
          'designed for Indian citizens. It provides easy access to helpline '
          'numbers, legal guidance, emergency checklists, and educational '
          'content about your rights.\n\n'
          'Built to empower individuals with knowledge when it matters most.',
          style: TextStyle(
              fontSize: 13, color: style.inkMutedColor, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CLOSE',
                style: TextStyle(color: style.accentColor,
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(
      BuildContext context, String url, AppStyle style) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: $url'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(
      BuildContext context, String email, String subject, AppStyle style) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email client.'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  void _shareApp() {
    Share.share(
      'Check out LexCheck – your legal awareness companion!\n'
      'Download it here: $_kPlayStoreUrl',
    );
  }
}

// ─── Private sub-widgets (reused patterns from original file) ─────────────────

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.style});
  final String title;
  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 12,
        color: style.inkMutedColor,
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
    required this.style,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppStyle style;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: style.inkColor)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style:
                        TextStyle(fontSize: 11.5, color: style.inkMutedColor)),
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
  final VoidCallback? onTap;
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
