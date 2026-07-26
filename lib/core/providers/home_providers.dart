import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/news_models.dart';
import '../services/news_service.dart';
import '../services/risk_scan_service.dart';

// ---------------------------------------------------------------------------
// News provider — fetches live legal news from NewsData.io
// ---------------------------------------------------------------------------

/// Async provider: resolves to a list of Indian legal news articles.
/// Riverpod caches the result for the lifetime of the provider (one API call
/// per app session). Invalidate with [ref.invalidate(legalNewsProvider)]
/// to force a refresh.
final legalNewsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  return NewsService().fetchLegalNews();
});

// ---------------------------------------------------------------------------
// Risk Scan provider — manages document scan state machine
// ---------------------------------------------------------------------------

enum ScanStatus { idle, loading, success, error }

class ScanState {
  final ScanStatus status;
  final ScanResult? result;
  final String? error;
  final String? fileName;

  const ScanState({
    this.status = ScanStatus.idle,
    this.result,
    this.error,
    this.fileName,
  });

  ScanState copyWith({
    ScanStatus? status,
    ScanResult? result,
    String? error,
    String? fileName,
  }) {
    return ScanState(
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      fileName: fileName ?? this.fileName,
    );
  }
}

class RiskScanNotifier extends StateNotifier<ScanState> {
  RiskScanNotifier() : super(const ScanState());

  /// Upload a document and run risk analysis. No-ops if already loading.
  Future<void> scan(String fileName, Uint8List bytes) async {
    if (state.status == ScanStatus.loading) return;

    state = ScanState(status: ScanStatus.loading, fileName: fileName);

    try {
      final result = await RiskScanService().scanDocument(fileName, bytes);
      state = ScanState(status: ScanStatus.success, result: result, fileName: fileName);
    } catch (e) {
      state = ScanState(
        status: ScanStatus.error,
        error: e.toString().replaceFirst('Exception: ', ''),
        fileName: fileName,
      );
    }
  }

  /// Reset back to idle so the user can upload another document.
  void reset() => state = const ScanState();
}

/// Global provider for document scan state.
final riskScanProvider =
    StateNotifierProvider<RiskScanNotifier, ScanState>((_) => RiskScanNotifier());
