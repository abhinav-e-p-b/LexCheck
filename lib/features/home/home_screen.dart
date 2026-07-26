import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/models.dart';
import '../../core/data/news_models.dart';
import '../../core/providers/home_providers.dart';
import '../../core/providers/mock_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/labels.dart';
import '../../core/widgets/ring_gauge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppTopBar(),
      floatingActionButton: isDark
          ? null
          : FloatingActionButton(
              backgroundColor: context.appStyle.accentColor,
              foregroundColor: context.appStyle.inkColor,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: isDark ? const _DarkHomeBody() : const _LightHomeBody(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LIGHT THEME BODY
// ---------------------------------------------------------------------------
class _LightHomeBody extends ConsumerWidget {
  const _LightHomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = context.appStyle;
    final newsAsync = ref.watch(legalNewsProvider);
    final scanState = ref.watch(riskScanProvider);
    final recentDocs = ref.watch(recentDocumentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Safety Profile ──────────────────────────────────────────────────
        AppCard(
          child: Column(
            children: [
              Text('SAFETY PROFILE',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: style.inkColor)),
              const SizedBox(height: 12),
              RingGauge(
                percent: 82,
                trackColor: style.borderColor.withValues(alpha: 0.15),
                progressColor: style.inkColor,
                centerText: '82',
                centerSubText: 'OPTIMAL',
                textColor: style.inkColor,
              ),
              const SizedBox(height: 12),
              Text(
                'Your legal health is currently stable. 2 minor risks '
                'detected in active contracts.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: style.inkMutedColor),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Instant Risk Scanner ────────────────────────────────────────────
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INSTANT RISK SCANNER',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: style.inkColor)),
              const SizedBox(height: 8),
              Text(
                'Upload any legal document (PDF, DOCX, TXT) to analyze for '
                'predatory clauses, hidden liabilities, and non-compliance '
                'markers in real-time.',
                style: TextStyle(fontSize: 12.5, color: style.inkMutedColor),
              ),
              const SizedBox(height: 14),

              // State-driven content
              if (scanState.status == ScanStatus.success &&
                  scanState.result != null)
                _ScanResultCard(result: scanState.result!, style: style)
              else if (scanState.status == ScanStatus.loading)
                _ScanLoadingCard(
                    fileName: scanState.fileName ?? 'document', style: style)
              else if (scanState.status == ScanStatus.error)
                _ScanErrorCard(
                    error: scanState.error ?? 'Unknown error', style: style)
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: style.cardBackgroundAlt,
                    border: Border.all(
                        color: style.borderColor.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          color: style.inkMutedColor, size: 28),
                      const SizedBox(height: 8),
                      Text('DRAG & DROP FILES',
                          style: TextStyle(
                              color: style.inkMutedColor,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('PDF · DOCX · TXT',
                          style: TextStyle(
                              color: style.inkMutedColor, fontSize: 11)),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              if (scanState.status == ScanStatus.success)
                AppButton(
                  label: 'SCAN ANOTHER DOCUMENT',
                  icon: Icons.refresh,
                  dense: true,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => ref.read(riskScanProvider.notifier).reset(),
                )
              else
                AppButton(
                  label: scanState.status == ScanStatus.loading
                      ? 'SCANNING...'
                      : 'UPLOAD DOCUMENT',
                  icon: Icons.file_upload_outlined,
                  dense: true,
                  onPressed: () async {
                    if (scanState.status == ScanStatus.loading) return;

                    final picked = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'docx', 'txt'],
                      withData: true, // Required on Flutter Web
                    );

                    if (picked != null && picked.files.isNotEmpty) {
                      final file = picked.files.first;
                      if (file.bytes != null) {
                        // Add to recent activity immediately
                        ref
                            .read(recentDocumentsProvider.notifier)
                            .addDocument(RecentDocument(file.name, 'Scanning...'));
                        // Start scan
                        ref
                            .read(riskScanProvider.notifier)
                            .scan(file.name, file.bytes!);
                      }
                    }
                  },
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Trending Legal Risks (live news) ────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: style.inkColor),
                const SizedBox(width: 6),
                Text('TRENDING LEGAL RISKS',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: style.inkColor)),
              ],
            ),
            GestureDetector(
              onTap: () => ref.invalidate(legalNewsProvider),
              child: Text('REFRESH',
                  style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        newsAsync.when(
          loading: () => const _NewsLoadingCard(),
          error: (e, _) => _NewsErrorCard(
            message: e.toString().replaceFirst('Exception: ', ''),
            onRetry: () => ref.invalidate(legalNewsProvider),
          ),
          data: (articles) => articles.isEmpty
              ? _NewsErrorCard(
                  message: 'No legal news available right now.',
                  onRetry: () => ref.invalidate(legalNewsProvider),
                )
              : Column(
                  children: [
                    for (final article in articles.take(4)) ...[
                      _NewsRiskCard(article: article, style: style),
                      const SizedBox(height: 14),
                    ]
                  ],
                ),
        ),

        // ── LexChat AI ──────────────────────────────────────────────────────
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: style.accentColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.smart_toy_outlined,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text('LEXCHAT AI',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: style.inkColor)),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text('ONLINE',
                          style: TextStyle(
                              fontSize: 10, color: style.inkMutedColor)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: style.borderColor, width: 1.2),
                ),
                child: Text('How can I assist your legal review today?',
                    style:
                        TextStyle(fontSize: 12.5, color: style.inkMutedColor)),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: style.accentColor),
                  child: const Text(
                    'Check my employment contract for non-compete issues.',
                    style: TextStyle(fontSize: 12.5, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AppButton(
                label: 'OPEN FULL CHAT',
                icon: Icons.arrow_forward,
                variant: AppButtonVariant.dark,
                dense: true,
                onPressed: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Recent Activity ─────────────────────────────────────────────────
        Text('RECENT ACTIVITY',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: style.inkMutedColor)),
        const SizedBox(height: 10),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < recentDocs.length; i++) ...[
                _RecentDocTile(doc: recentDocs[i]),
                if (i != recentDocs.length - 1)
                  Divider(
                      height: 1,
                      color: style.borderColor.withValues(alpha: 0.3)),
              ],
              if (recentDocs.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('No recent documents.',
                      style: TextStyle(
                          color: style.inkMutedColor, fontSize: 12.5)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Light body: News card (live data)
// ---------------------------------------------------------------------------

String _badgeForArticle(NewsArticle article) {
  final text = '${article.title} ${article.description}'.toLowerCase();
  const highRisk = [
    'arrest', 'criminal', 'fraud', 'scam', 'penalty', 'fine', 'court order',
    'violation', 'fir', 'bail', 'corruption', 'illegal', 'sue', 'charged',
    'convicted', 'raided', 'seized',
  ];
  return highRisk.any(text.contains) ? 'HIGH RISK' : 'UPDATE';
}

class _NewsRiskCard extends StatelessWidget {
  const _NewsRiskCard({required this.article, required this.style});
  final NewsArticle article;
  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    final badge = _badgeForArticle(article);
    final badgeColor =
        badge == 'HIGH RISK' ? AppColors.lightHighRiskBg : AppColors.lightUpdateBg;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration:
                    BoxDecoration(color: badgeColor.withValues(alpha: 0.85)),
                child: Icon(
                  badge == 'HIGH RISK' ? Icons.gavel : Icons.newspaper,
                  color: Colors.white24,
                  size: 44,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: BadgeChip(text: badge, background: badgeColor),
              ),
              if (article.sourceName != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    color: Colors.black45,
                    child: Text(
                      article.sourceName!,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: style.inkColor)),
                const SizedBox(height: 4),
                Text(article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12, color: style.inkMutedColor)),
                if (article.publishedAt != null) ...[
                  const SizedBox(height: 6),
                  Text(article.publishedAt!,
                      style: TextStyle(
                          fontSize: 10, color: style.inkMutedColor)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsLoadingCard extends StatelessWidget {
  const _NewsLoadingCard();

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: style.accentColor),
          ),
          const SizedBox(width: 12),
          Text('FETCHING LIVE LEGAL NEWS...',
              style: TextStyle(fontSize: 12, color: style.inkMutedColor)),
        ],
      ),
    );
  }
}

class _NewsErrorCard extends StatelessWidget {
  const _NewsErrorCard({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return AppCard(
      child: Column(
        children: [
          Icon(Icons.wifi_off, color: style.inkMutedColor, size: 28),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: style.inkMutedColor)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onRetry,
            child: Text('TAP TO RETRY',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: style.accentColor,
                    decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scan result widgets
// ---------------------------------------------------------------------------

class _ScanLoadingCard extends StatelessWidget {
  const _ScanLoadingCard({required this.fileName, required this.style});
  final String fileName;
  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
      decoration: BoxDecoration(
        color: style.cardBackgroundAlt,
        border: Border.all(color: style.borderColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: style.accentColor),
          ),
          const SizedBox(height: 12),
          Text('SCANNING: $fileName',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: style.inkColor)),
          const SizedBox(height: 4),
          Text('Analyzing clauses via LexCheck AI…',
              style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
        ],
      ),
    );
  }
}

class _ScanErrorCard extends StatelessWidget {
  const _ScanErrorCard({required this.error, required this.style});
  final String error;
  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 18),
              const SizedBox(width: 8),
              Text('SCAN FAILED',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.red.shade400,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text(error,
              style: TextStyle(fontSize: 12, color: Colors.red.shade600)),
        ],
      ),
    );
  }
}

class _ScanResultCard extends StatelessWidget {
  const _ScanResultCard({required this.result, required this.style});
  final ScanResult result;
  final AppStyle style;

  Color _levelColor() {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return AppColors.lightHighRiskBg;
      case RiskLevel.low:
        return Colors.green.shade600;
      default:
        return Colors.orange.shade700;
    }
  }

  String _levelLabel() {
    switch (result.riskLevel) {
      case RiskLevel.high:
        return 'HIGH RISK';
      case RiskLevel.low:
        return 'LOW RISK';
      default:
        return 'MEDIUM RISK';
    }
  }

  Color _flagColor(RiskSeverity s) {
    switch (s) {
      case RiskSeverity.high:
        return Colors.red.shade400;
      case RiskSeverity.low:
        return Colors.green.shade600;
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall risk badge
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          color: levelColor.withValues(alpha: 0.12),
          child: Row(
            children: [
              Icon(
                result.riskLevel == RiskLevel.high
                    ? Icons.warning_amber_rounded
                    : result.riskLevel == RiskLevel.low
                        ? Icons.check_circle_outline
                        : Icons.info_outline,
                color: levelColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_levelLabel(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: levelColor,
                            fontSize: 13)),
                    Text(result.fileName,
                        style: TextStyle(
                            fontSize: 10, color: style.inkMutedColor)),
                  ],
                ),
              ),
              Text(
                  '${(result.confidence * 100).toStringAsFixed(0)}% conf.',
                  style: TextStyle(fontSize: 10, color: style.inkMutedColor)),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Summary
        Text(result.summary,
            style: TextStyle(fontSize: 12.5, color: style.inkMutedColor)),

        // Flags
        if (result.flags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('FLAGGED CLAUSES (${result.flags.length})',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: style.inkColor)),
          const SizedBox(height: 8),
          for (final flag in result.flags) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: _flagColor(flag.severity), width: 3),
                ),
                color: style.cardBackgroundAlt,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        color: _flagColor(flag.severity),
                        child: Text(
                          flag.severity.name.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('"${flag.clause}"',
                      style: TextStyle(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: style.inkColor)),
                  const SizedBox(height: 4),
                  Text(flag.reason,
                      style: TextStyle(
                          fontSize: 11.5, color: style.inkMutedColor)),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared: Recent doc tile
// ---------------------------------------------------------------------------

class _RecentDocTile extends StatelessWidget {
  const _RecentDocTile({required this.doc});
  final RecentDocument doc;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;

    Color statusColor = style.inkMutedColor;
    if (doc.status.contains('HIGH') || doc.status.contains('FLAGGED')) {
      statusColor = AppColors.lightHighRiskBg;
    } else if (doc.status.contains('CLEAN') || doc.status.contains('LOW')) {
      statusColor = Colors.green.shade600;
    } else if (doc.status.contains('Scanning') ||
        doc.status.contains('SCANNING')) {
      statusColor = Colors.orange.shade700;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined,
              size: 18, color: style.inkMutedColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(doc.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: style.inkColor)),
          ),
          const SizedBox(width: 8),
          Text(doc.status,
              style: TextStyle(fontSize: 10, color: statusColor)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DARK THEME BODY
// ---------------------------------------------------------------------------
class _DarkHomeBody extends ConsumerWidget {
  const _DarkHomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = context.appStyle;
    final recentDocs = ref.watch(recentDocumentsProvider);
    final highRisks = ref.watch(highRiskAlertsDarkProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              color: style.accentColor,
            ),
            Text('SYSTEM OVERVIEW',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: style.inkColor)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14, top: 2),
          child: Text('LEXCHECK ENGINE OPERATIONAL // 0.82_LOAD',
              style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: _MetaBox(label: 'LATENCY: 12ms')),
            SizedBox(width: 10),
            Expanded(child: _MetaBox(label: 'STATUS: OPTIMAL')),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SAFETY PROFILE',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: style.inkColor)),
              const SizedBox(height: 12),
              Center(
                child: RingGauge(
                  percent: 82,
                  trackColor: style.borderColor.withValues(alpha: 0.3),
                  progressColor: style.accentColor,
                  centerText: '82%',
                  centerSubText: 'OPTIMAL',
                  textColor: style.inkColor,
                ),
              ),
              const SizedBox(height: 16),
              const _MetricBar(label: 'COMPLIANCE', value: '94/100', percent: 0.94),
              const SizedBox(height: 10),
              const _MetricBar(
                  label: 'LIABILITY GAP',
                  value: '12%',
                  percent: 0.12,
                  color: AppColors.darkCritical),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RECENT ACTIVITY',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: style.inkColor)),
              const SizedBox(height: 10),
              for (final doc in recentDocs.take(3))
                _DarkDocRow(name: doc.name, status: doc.status.toUpperCase()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('INSTANT RISK SCANNER',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: style.inkColor)),
                  BadgeChip(
                      text: 'LIVE_FEED', background: style.accentColor),
                ],
              ),
              const SizedBox(height: 12),
              DottedBorderBox(
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        color: style.inkMutedColor, size: 26),
                    const SizedBox(height: 8),
                    Text('DRAG & DROP CONTRACTS HERE',
                        style: TextStyle(color: style.inkMutedColor)),
                    const SizedBox(height: 4),
                    const MutedCaption('SUPPORTED: PDF, DOCX, TXT (MAX 50MB)'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'UPLOAD MANUALLY',
                icon: Icons.file_upload_outlined,
                dense: true,
                onPressed: () async {
                  final picked = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'docx', 'txt'],
                    withData: true,
                  );
                  if (picked != null && picked.files.isNotEmpty) {
                    final file = picked.files.first;
                    if (file.bytes != null) {
                      ref.read(recentDocumentsProvider.notifier).addDocument(
                          RecentDocument(file.name, 'SCANNING...'));
                    }
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: style.accentColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(Icons.smart_toy_outlined,
                        color: style.scaffoldBackground, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text('LexChat AI v2.4',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: style.inkColor)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'ANALYSIS COMPLETE. I found 3 high-risk clauses in '
                "'Service_Agreement_V4.pdf'. Would you like me to suggest "
                'remediation text?',
                style:
                    TextStyle(fontSize: 12.5, color: style.inkMutedColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('HIGH RISK ALERTS',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: style.accentColor)),
        const SizedBox(height: 10),
        for (final risk in highRisks) ...[
          _DarkAlertCard(risk: risk),
          const SizedBox(height: 12),
        ],
        AppCard(
          alt: true,
          child: Text(
            '[08:41:22] :: HANDSHAKE_INITIATED\n'
            '[08:41:23] :: SSL_LAYER_READY\n'
            '[08:42:01] :: UPLOAD_DETECTED\n'
            '  Service_Agreement_V4.pdf\n'
            '[08:42:02] :: OCR_ENGINE_SCANNING...\n'
            '[08:45:12] :: ANALYSIS_COMPLETE: 3 FLAGS FOUND\n'
            '[08:45:12] :: CHATBOT_QUERY: "risk_summary"',
            style: TextStyle(
                fontSize: 10.5, color: style.inkMutedColor, height: 1.6),
          ),
        ),
      ],
    );
  }
}

class _MetaBox extends StatelessWidget {
  const _MetaBox({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
    );
  }
}

class _MetricBar extends StatelessWidget {
  const _MetricBar({
    required this.label,
    required this.value,
    required this.percent,
    this.color,
  });

  final String label;
  final String value;
  final double percent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(fontSize: 11, color: style.inkMutedColor)),
            Text(value,
                style: TextStyle(fontSize: 11, color: style.inkColor)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: style.borderColor.withValues(alpha: 0.25),
            valueColor: AlwaysStoppedAnimation(color ?? style.accentColor),
          ),
        ),
      ],
    );
  }
}

class _DarkDocRow extends StatelessWidget {
  const _DarkDocRow({required this.name, required this.status});
  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined,
              size: 16, color: style.inkMutedColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name,
                style: TextStyle(fontSize: 12.5, color: style.inkColor)),
          ),
          Text(status,
              style: TextStyle(fontSize: 10, color: style.inkMutedColor)),
        ],
      ),
    );
  }
}

class _DarkAlertCard extends StatelessWidget {
  const _DarkAlertCard({required this.risk});
  final TrendingRisk risk;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final badgeColor = risk.badge == 'CRITICAL'
        ? AppColors.darkCritical
        : AppColors.darkModerate;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: style.cardBackgroundAlt,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(style.cardRadius)),
                ),
                child: Icon(Icons.shield_outlined,
                    color: style.inkMutedColor.withValues(alpha: 0.4),
                    size: 44),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: BadgeChip(text: risk.badge, background: badgeColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(risk.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: style.inkColor)),
                const SizedBox(height: 4),
                Text(risk.description,
                    style: TextStyle(
                        fontSize: 11.5, color: style.inkMutedColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed-border drop zone used by the dark "Instant Risk Scanner" card.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return CustomPaint(
      painter: _DashedBorderPainter(color: style.borderColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rect = Offset.zero & size;
    var path = Path()..addRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}
