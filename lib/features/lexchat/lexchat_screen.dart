import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/models.dart';
import '../../core/providers/mock_providers.dart';
import '../../core/services/lex_api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/labels.dart';
import '../../core/widgets/semi_dial_gauge.dart';

class LexChatScreen extends ConsumerStatefulWidget {
  const LexChatScreen({super.key});

  @override
  ConsumerState<LexChatScreen> createState() => _LexChatScreenState();
}

class _LexChatScreenState extends ConsumerState<LexChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _apiService = LexApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    _controller.clear();

    // Add user message immediately
    ref
        .read(chatThreadProvider.notifier)
        .addMessage(ChatMessage(fromBot: false, text: text));
    _scrollToBottom();

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.sendMessage(text);

      // Format sources block
      String sourceSummary = '';
      if (response.sources.isNotEmpty) {
        final newsCount =
            response.sources.where((s) => s.dataset == 'news').length;
        final legalCount =
            response.sources.where((s) => s.dataset == 'legal').length;
        sourceSummary =
            '\n\n📊 Sources: $newsCount news article(s), $legalCount legal document(s) retrieved'
            '\n⏱ Processed in ${response.processingTime.toStringAsFixed(2)}s'
            '\n🎯 Confidence: ${(response.confidence * 100).toStringAsFixed(1)}%';
      }

      ref.read(chatThreadProvider.notifier).addMessage(
            ChatMessage(fromBot: true, text: response.answer + sourceSummary),
          );
    } catch (e) {
      ref.read(chatThreadProvider.notifier).addMessage(
            ChatMessage(
              fromBot: true,
              text:
                  '⚠️ Backend Error: ${e.toString().replaceAll('Exception: ', '')}\n\n'
                  'Make sure:\n'
                  '1. The Python backend is running (uvicorn app.main:app --port 8000)\n'
                  '2. Datasets have been ingested (python -m app.ingest)\n'
                  '3. Ollama is running with a model loaded',
            ),
          );
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = ref.watch(chatThreadProvider);

    return Scaffold(
      appBar: const AppTopBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                            const Wrap(
                              spacing: 8,
                              children: [
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
                                    decoration: const BoxDecoration(
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
                    for (final msg in messages) ...[
                      _ChatBubble(message: msg),
                      const SizedBox(height: 12),
                    ],
                    if (_isLoading) ...[
                      const SizedBox(height: 4),
                      _TypingIndicator(),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            _ChatInputBar(
              controller: _controller,
              onSend: _sendMessage,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated typing indicator shown while waiting for the LLM.
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: style.inkColor,
          child: Icon(Icons.smart_toy_outlined,
              size: 14, color: style.accentColor),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: style.cardBackground,
            border:
                Border.all(color: style.borderColor, width: style.borderWidth),
            borderRadius: BorderRadius.circular(style.cardRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final offset =
                      ((_controller.value + i * 0.3) % 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Transform.translate(
                      offset: Offset(0, -4 * (1 - (2 * offset - 1).abs())),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: style.inkMutedColor,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        Text('LEX_SYS is thinking...',
            style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
      ],
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
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

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
              onSubmitted: (_) => onSend(),
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: isLoading
                    ? 'Waiting for LEX_SYS response...'
                    : isDark
                        ? 'Enter legal command'
                        : 'Ask about Indian news or law...',
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
            onTap: isLoading ? null : onSend,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isLoading
                    ? style.borderColor
                    : style.accentColor,
                borderRadius: BorderRadius.circular(style.cardRadius),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: style.inkColor,
                      ),
                    )
                  : Icon(
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
