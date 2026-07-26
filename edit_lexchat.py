import re
import os

# 1. Edit lexchat_screen.dart
path = r"d:\Sreehari\LexCheck\lib\features\lexchat\lexchat_screen.dart"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace _sendMessage message mapping
content = content.replace(
"""      ref.read(chatThreadProvider.notifier).addMessage(
            ChatMessage(fromBot: true, text: response.answer + sourceSummary),
          );""",
"""      ref.read(chatThreadProvider.notifier).addMessage(
            ChatMessage(
              fromBot: true, 
              text: response.explanation + sourceSummary,
              severity: response.severity,
              verdict: response.verdict,
              lawsCited: response.lawsCited,
              caseLens: response.caseLens,
            ),
          );"""
)

# Update backend error text
content = content.replace("3. Ollama is running with a model loaded", "3. Groq API Key is set in config.py")

# Add build logic
old_build = """  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = ref.watch(chatThreadProvider);"""
new_build = """  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = ref.watch(chatThreadProvider);
    final lastBotMsg = messages.reversed.firstWhere(
      (m) => m.fromBot,
      orElse: () => const ChatMessage(fromBot: true, text: ''),
    );

    double gaugePercent = 0;
    String verdictTitle = isDark ? 'GREY_AREA_VERDICT' : 'GREY AREA VERDICT';
    String severityLabel = 'CAUTION';
    Color needleColor = style.inkColor;
    
    if (lastBotMsg.severity != null) {
      final s = lastBotMsg.severity!.toLowerCase();
      if (s == 'safe') { gaugePercent = 15; severityLabel = 'SAFE'; needleColor = Colors.green; }
      else if (s == 'minor') { gaugePercent = 35; severityLabel = 'MINOR RISK'; needleColor = Colors.yellow; }
      else if (s == 'caution') { gaugePercent = 50; severityLabel = 'CAUTION'; needleColor = Colors.orange; }
      else if (s == 'serious') { gaugePercent = 80; severityLabel = 'SERIOUS RISK'; needleColor = Colors.red; }
      else if (s == 'criminal') { gaugePercent = 95; severityLabel = 'CRIMINAL'; needleColor = AppColors.darkCritical; }
      else if (s == 'out of scope') { gaugePercent = 0; severityLabel = 'OUT OF SCOPE'; needleColor = Colors.grey; }
      verdictTitle = isDark ? severityLabel.replaceAll(' ', '_') : severityLabel;
    } else {
      gaugePercent = 50;
    }"""
content = content.replace(old_build, new_build)

# Replace the AppCard block
# Find the start of AppCard in the SingleChildScrollView
appcard_pattern = re.compile(
    r"AppCard\(\s*child: Column\(\s*children: \[\s*Text\(\s*isDark \? 'GREY_AREA_VERDICT'.*?\]\s*else \.\.\.\[.*?\]\s*,\s*\]\s*,\s*\)\s*,\s*\)", 
    re.DOTALL
)

new_appcard = """AppCard(
                      child: Column(
                        children: [
                          Text(
                            verdictTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: style.inkColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SemiDialGauge(
                            percent: gaugePercent,
                            zoned: isDark,
                            needleColor: needleColor,
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
                          if (lastBotMsg.severity != null) ...[
                             if (isDark)
                               BadgeChip(
                                 text: verdictTitle,
                                 background: needleColor,
                               ),
                             const SizedBox(height: 12),
                             Text(
                               lastBotMsg.verdict ?? '',
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   fontSize: 13, color: style.inkColor, height: 1.5, fontWeight: FontWeight.w700),
                             ),
                             if (lastBotMsg.caseLens != null && lastBotMsg.caseLens!.isNotEmpty) ...[
                               const SizedBox(height: 12),
                               Text(
                                 'CaseLens: ' + lastBotMsg.caseLens!,
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     fontSize: 12, color: style.inkMutedColor, fontStyle: FontStyle.italic),
                               ),
                             ],
                             const SizedBox(height: 12),
                             if (lastBotMsg.lawsCited != null && lastBotMsg.lawsCited!.isNotEmpty)
                               Wrap(
                                 spacing: 8,
                                 children: lastBotMsg.lawsCited!.map((l) => _HashTag('#' + l.replaceAll(' ', '_'))).toList(),
                               ),
                          ] else ...[
                             Text(
                               'Ask a legal query below to receive an instant verdict and risk analysis.',
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   fontSize: 12.5, color: style.inkMutedColor),
                             ),
                          ],
                        ],
                      ),
                    )"""

content = re.sub(appcard_pattern, new_appcard, content)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)

print("lexchat_screen.dart updated")

# 2. Edit home_screen.dart
path2 = r"d:\Sreehari\LexCheck\lib\features\home\home_screen.dart"
with open(path2, "r", encoding="utf-8") as f:
    content2 = f.read()

# Add import if not present
if "import '../../core/providers/shell_provider.dart';" not in content2:
    content2 = content2.replace("import '../../core/providers/mock_providers.dart';", "import '../../core/providers/mock_providers.dart';\nimport '../../core/providers/shell_provider.dart';")

# Fix floating action button
content2 = content2.replace("onPressed: () {},", "onPressed: () => ref.read(shellIndexProvider.notifier).state = 1,")

with open(path2, "w", encoding="utf-8") as f:
    f.write(content2)

print("home_screen.dart updated")
