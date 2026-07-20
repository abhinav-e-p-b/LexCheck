import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// Small orange-square bullet label, e.g. "■ HOW OLD ARE YOU?"
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, color: style.accentColor),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: style.inkColor,
          ),
        ),
      ],
    );
  }
}

/// Small rectangular status chip, e.g. "HIGH RISK", "UPDATE", "CRITICAL".
class BadgeChip extends StatelessWidget {
  const BadgeChip({
    super.key,
    required this.text,
    required this.background,
    this.foreground = Colors.white,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// A caption row used for terminal-style meta text, e.g.
/// "SUPPORTED: PDF, DOCX, TXT (MAX 50MB)".
class MutedCaption extends StatelessWidget {
  const MutedCaption(this.text, {super.key, this.fontSize = 11});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Text(
      text,
      style: TextStyle(
        color: style.inkMutedColor,
        fontSize: fontSize,
      ),
    );
  }
}
