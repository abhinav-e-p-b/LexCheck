import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/labels.dart';
import '../../core/widgets/semi_dial_gauge.dart';

class LexChatScreen extends StatefulWidget {
  const LexChatScreen({super.key});

  @override
  State<LexChatScreen> createState() => _LexChatScreenState();
}

class _LexChatScreenState extends State<LexChatScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppTopBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      child: Column(
                        children: [
                          Text(
                            isDark ? 'GREY_AREA_VERDICT' : 'GREY AREA VERDICT',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: style.inkColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SemiDialGauge(
                            percent: 74,
                            zoned: isDark,
                            needleColor: style.inkColor,
                            arcColor: style.inkColor,
                            lowColor: AppColors.darkGaugeLow,
                            midColor: AppColors.darkGaugeMid,
                            highColor: AppColors.darkGaugeHigh,
                          ),
                          if (isDark) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('LOW',
                                    style: TextStyle(
                                        fontSize: 10, color: style.inkMutedColor)),
                                Text('MID',
                                    style: TextStyle(
                                        fontSize: 10, color: style.inkMutedColor)),
                                Text('HIGH_RISK',
                                    style: TextStyle(
                                        fontSize: 10, color: style.inkMutedColor)),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),
                          if (isDark) ...[
                            const BadgeChip(
                              text: 'CRITICAL_EXCEPTION_FOUND',
                              background: AppColors.darkCritical,
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 13, color: style.inkColor, height: 1.5),
                                children: [
                                  const TextSpan(
                                      text: 'The current legal query explores '),
                                  TextSpan(
                                    text: 'non-standard jurisdictional bypasses',
                                    style: TextStyle(color: style.accentColor),
                                  ),
                                  const TextSpan(
                                      text: '. Initial telemetry suggests a '),
                                  TextSpan(
                                    text: '87.4% alignment',
                                    style: TextStyle(
                                        color: style.accentColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const TextSpan(
                                    text:
                                        ' with Section 12-B High-Risk patterns. '
                                        'Proceed with automated synthesis at '
                                        'your own discretion.',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: const [
                                _HashTag('#RISK_MOD_4'),
                                _HashTag('#PROTOCOL_0_9'),
                                _HashTag('#LEGAL_GREY'),
                              ],
                            ),
                          ] else ...[
                            Text(
                              'The current clause demonstrates high risk (74%) '
                              'regarding intellectual property transfer. '
                              'Suggesting immediate renegotiation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12.5, color: style.inkMutedColor),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.lightHighRiskBg),
                                    child: const Center(
                                      child: Text('HIGH RISK',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: style.borderColor,
                                          width: style.borderWidth),
                                    ),
                                    child: Center(
                                      child: Text('IP RIGHTS',
                                          style: TextStyle(
                                              color: style.inkColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final msg in MockData.chatThread) ...[
                      _ChatBubble(message: msg),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            _ChatInputBar(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class _HashTag extends StatelessWidget {
  const _HashTag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: style.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(fontSize: 10.5, color: style.inkMutedColor)),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (message.fromBot) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: style.inkColor,
            child: Icon(Icons.smart_toy_outlined,
                size: 14, color: style.accentColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isDark ? 'LEX_SYS' : 'LexBot 1.0',
                    style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: style.cardBackground,
                    border: Border.all(
                        color: style.borderColor, width: style.borderWidth),
                    borderRadius: BorderRadius.circular(style.cardRadius),
                  ),
                  child: Text(message.text,
                      style: TextStyle(fontSize: 13, color: style.inkColor)),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Me', style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: style.accentColor,
                  borderRadius: BorderRadius.circular(style.cardRadius),
                ),
                child: Text(message.text,
                    style: const TextStyle(fontSize: 13, color: Colors.black87)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 14,
          backgroundColor: style.cardBackgroundAlt,
          child: Icon(Icons.person_outline, size: 14, color: style.inkColor),
        ),
      ],
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: style.scaffoldBackground,
        border: Border(top: BorderSide(color: style.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: style.inkColor),
              decoration: InputDecoration(
                hintText: isDark ? 'Enter legal command' : 'Ask about specific clau',
                hintStyle: TextStyle(color: style.inkMutedColor, fontSize: 13),
                filled: true,
                fillColor: style.cardBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(style.cardRadius),
                  borderSide: BorderSide(color: style.borderColor),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: style.accentColor,
                borderRadius: BorderRadius.circular(style.cardRadius),
              ),
              child: Icon(
                isDark ? Icons.send : Icons.arrow_upward,
                size: 18,
                color: isDark ? style.scaffoldBackground : style.inkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
