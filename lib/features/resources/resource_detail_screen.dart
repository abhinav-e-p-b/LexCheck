import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/models.dart';
import '../../core/providers/mock_providers.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/labels.dart';

class ResourceDetailScreen extends ConsumerWidget {
  const ResourceDetailScreen({super.key, required this.service});

  final EmergencyService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = ref.watch(
        favoritesProvider.select((set) => set.contains(service.id)));

    return Scaffold(
      appBar: const AppTopBar(showBackButton: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // ── Header ──────────────────────────────────────────────────────
            AppCard(
              borderColor: isDark ? style.accentColor : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BadgeChip(
                        text: service.category.toUpperCase(),
                        background: style.accentColor,
                        foreground: Colors.black87,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            ref.read(favoritesProvider.notifier).toggle(service.id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red.shade400 : style.inkMutedColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: style.cardBackgroundAlt,
                          borderRadius: BorderRadius.circular(style.cardRadius),
                          border: Border.all(
                              color: style.borderColor, width: style.borderWidth),
                        ),
                        child: Icon(_iconFor(service.category),
                            color: style.inkColor, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          service.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: style.inkColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Description ──────────────────────────────────────────────────
            _SectionHeader(title: 'DESCRIPTION', style: style),
            const SizedBox(height: 8),
            AppCard(
              child: Text(
                service.description,
                style: TextStyle(
                    fontSize: 13, color: style.inkMutedColor, height: 1.5),
              ),
            ),
            const SizedBox(height: 14),

            // ── When to use ──────────────────────────────────────────────────
            _SectionHeader(title: 'WHEN TO USE', style: style),
            const SizedBox(height: 8),
            AppCard(
              child: Text(
                service.whenToUse,
                style: TextStyle(
                    fontSize: 13, color: style.inkMutedColor, height: 1.5),
              ),
            ),
            const SizedBox(height: 14),

            // ── Emergency guidance ───────────────────────────────────────────
            _SectionHeader(title: 'EMERGENCY GUIDANCE', style: style),
            const SizedBox(height: 8),
            AppCard(
              borderColor: style.accentColor,
              child: Text(
                service.emergencyGuidance,
                style: TextStyle(
                    fontSize: 13, color: style.inkColor, height: 1.7),
              ),
            ),
            const SizedBox(height: 14),

            // ── Contact info ─────────────────────────────────────────────────
            _SectionHeader(title: 'CONTACT INFORMATION', style: style),
            const SizedBox(height: 8),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'PHONE',
                    value: service.number,
                    style: style,
                    isDark: isDark,
                  ),
                  if (service.website != null) ...[
                    Divider(
                        height: 1,
                        color: style.borderColor.withValues(alpha: 0.3)),
                    _InfoRow(
                      icon: Icons.language_outlined,
                      label: 'WEBSITE',
                      value: service.website!,
                      style: style,
                      isDark: isDark,
                    ),
                  ],
                  if (service.address != null) ...[
                    Divider(
                        height: 1,
                        color: style.borderColor.withValues(alpha: 0.3)),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'ADDRESS',
                      value: service.address!,
                      style: style,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Action buttons ───────────────────────────────────────────────
            _PrimaryButton(
              label: 'CALL ${service.number}',
              icon: Icons.call,
              style: style,
              onTap: () => _call(context, ref, service),
            ),
            const SizedBox(height: 10),
            if (service.website != null) ...[
              _SecondaryButton(
                label: 'OPEN WEBSITE',
                icon: Icons.open_in_new,
                style: style,
                isDark: isDark,
                onTap: () => _openWebsite(context, service),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: _SecondaryButton(
                    label: 'SHARE',
                    icon: Icons.ios_share,
                    style: style,
                    isDark: isDark,
                    onTap: () => _share(service),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SecondaryButton(
                    label: 'COPY NUMBER',
                    icon: Icons.copy,
                    style: style,
                    isDark: isDark,
                    onTap: () => _copyNumber(context, service, style),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  Future<void> _call(
      BuildContext context, WidgetRef ref, EmergencyService service) async {
    ref.read(recentlyContactedProvider.notifier).add(service.id);
    final uri = Uri(scheme: 'tel', path: service.number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) _showError(context, 'Could not initiate call.');
    }
  }

  Future<void> _openWebsite(
      BuildContext context, EmergencyService service) async {
    final uri = Uri.parse(service.website!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) _showError(context, 'Could not open website.');
    }
  }

  void _share(EmergencyService service) {
    Share.share(
      '${service.title}\n'
      'Category: ${service.category}\n'
      'Phone: ${service.number}\n'
      '${service.website != null ? 'Website: ${service.website}\n' : ''}'
      '\n${service.description}\n'
      '\nShared via LexCheck – Legal Awareness App',
    );
  }

  void _copyNumber(
      BuildContext context, EmergencyService service, AppStyle style) {
    Clipboard.setData(ClipboardData(text: service.number));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Number ${service.number} copied to clipboard'),
        backgroundColor: style.accentColor,
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade400),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  IconData _iconFor(String category) {
    switch (category) {
      case 'Emergency':
        return Icons.local_police_outlined;
      case 'Women Safety':
        return Icons.support_agent;
      case 'Child Protection':
        return Icons.child_care;
      case 'Cyber Crime':
        return Icons.security;
      case 'Legal Aid':
        return Icons.gavel;
      case 'Consumer Rights':
        return Icons.shopping_bag_outlined;
      case 'Mental Health':
        return Icons.psychology_outlined;
      case 'Disaster Management':
        return Icons.warning_amber_rounded;
      case 'Road Safety':
        return Icons.directions_car_outlined;
      default:
        return Icons.info_outline;
    }
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.style});
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
        letterSpacing: 0.5,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.style,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppStyle style;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: style.accentColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 10, color: style.inkMutedColor)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: style.inkColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.style,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final AppStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: style.accentColor,
          borderRadius: BorderRadius.circular(style.cardRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.style,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final AppStyle style;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: style.cardBackground,
          borderRadius: BorderRadius.circular(style.cardRadius),
          border: Border.all(color: style.borderColor, width: style.borderWidth),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: style.inkColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: style.inkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
