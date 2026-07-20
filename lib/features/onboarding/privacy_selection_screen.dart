import 'package:flutter/material.dart';

import '../../core/theme/app_style.dart';
import '../../core/widgets/app_button.dart';
import '../shell/main_shell.dart';

enum _DataChoice { store, autoDelete, anonymous }

class PrivacySelectionScreen extends StatefulWidget {
  const PrivacySelectionScreen({super.key});

  @override
  State<PrivacySelectionScreen> createState() =>
      _PrivacySelectionScreenState();
}

class _PrivacySelectionScreenState extends State<PrivacySelectionScreen> {
  _DataChoice _choice = _DataChoice.anonymous;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(width: 22, height: 22, color: style.accentColor),
                  const SizedBox(width: 10),
                  Text(
                    'LEXCHECK_OS v1.0.4',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: style.inkColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              Text(
                'How should we handle your data?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: style.inkColor,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                    width: 90, height: 2, color: style.accentColor),
              ),
              const SizedBox(height: 14),
              Text(
                'THE FINAL STEP. CHOOSE YOUR COMFORT LEVEL.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.6,
                  color: style.inkMutedColor,
                ),
              ),
              const SizedBox(height: 28),
              _DataOption(
                icon: Icons.cloud_outlined,
                title: 'STORE MY DATA',
                description: 'Keep your history synced across devices.',
                selected: _choice == _DataChoice.store,
                onTap: () => setState(() => _choice = _DataChoice.store),
              ),
              const SizedBox(height: 16),
              _DataOption(
                icon: Icons.access_time,
                title: 'AUTO-DELETE HISTORY',
                description: 'Wipe everything after 24 hours.',
                selected: _choice == _DataChoice.autoDelete,
                onTap: () => setState(() => _choice = _DataChoice.autoDelete),
              ),
              const SizedBox(height: 16),
              _DataOption(
                icon: Icons.gpp_maybe_outlined,
                title: 'ALWAYS STAY ANONYMOUS',
                description: 'No history, no logs, absolute privacy.',
                selected: _choice == _DataChoice.anonymous,
                onTap: () => setState(() => _choice = _DataChoice.anonymous),
                highlight: true,
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'START EXPLORING',
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                  (route) => false,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '> YOU CAN ALWAYS CHANGE THIS LATER IN SETTINGS.',
                  style: TextStyle(fontSize: 11, color: style.inkMutedColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataOption extends StatelessWidget {
  const _DataOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final borderColor = selected ? style.accentColor : style.borderColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(style.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected && highlight
              ? style.cardBackgroundAlt
              : style.cardBackground,
          borderRadius: BorderRadius.circular(style.cardRadius),
          border: Border.all(
            color: borderColor,
            width: selected ? 2 : style.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: style.shadowColor,
              offset: style.shadowOffset,
              blurRadius: style.shadowBlur,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: style.inkColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: style.inkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: style.inkMutedColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
