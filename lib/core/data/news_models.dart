/// Data model for a legal news article from NewsData.io
class NewsArticle {
  final String title;
  final String description;
  final String? url;
  final String? publishedAt;
  final String? sourceName;

  const NewsArticle({
    required this.title,
    required this.description,
    this.url,
    this.publishedAt,
    this.sourceName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: (json['title'] as String? ?? '').trim(),
      description: (json['description'] as String? ??
              json['content'] as String? ??
              'No description available.')
          .trim(),
      url: json['link'] as String?,
      publishedAt: json['pubDate'] as String?,
      sourceName: json['source_name'] as String?,
    );
  }
}

/// Severity of a single flagged clause inside a document.
enum RiskSeverity { high, medium, low }

RiskSeverity _parseSeverity(String raw) {
  switch (raw.toUpperCase()) {
    case 'HIGH':
      return RiskSeverity.high;
    case 'LOW':
      return RiskSeverity.low;
    default:
      return RiskSeverity.medium;
  }
}

/// A single problematic clause found during risk scanning.
class RiskFlag {
  final String clause;
  final String reason;
  final RiskSeverity severity;

  const RiskFlag({
    required this.clause,
    required this.reason,
    required this.severity,
  });

  factory RiskFlag.fromJson(Map<String, dynamic> json) {
    return RiskFlag(
      clause: json['clause'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      severity: _parseSeverity(json['severity'] as String? ?? 'MEDIUM'),
    );
  }
}

/// Overall risk level of a scanned document.
enum RiskLevel { high, medium, low }

RiskLevel _parseRiskLevel(String raw) {
  switch (raw.toUpperCase()) {
    case 'HIGH':
      return RiskLevel.high;
    case 'LOW':
      return RiskLevel.low;
    default:
      return RiskLevel.medium;
  }
}

/// Full result returned by the backend /scan endpoint.
class ScanResult {
  final RiskLevel riskLevel;
  final List<RiskFlag> flags;
  final String summary;
  final double confidence;
  final String fileName;

  const ScanResult({
    required this.riskLevel,
    required this.flags,
    required this.summary,
    required this.confidence,
    required this.fileName,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json, String fileName) {
    final flagsList = (json['flags'] as List<dynamic>? ?? [])
        .map((f) => RiskFlag.fromJson(f as Map<String, dynamic>))
        .toList();

    return ScanResult(
      riskLevel: _parseRiskLevel(json['risk_level'] as String? ?? 'MEDIUM'),
      flags: flagsList,
      summary: json['summary'] as String? ?? 'Analysis complete.',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.7,
      fileName: fileName,
    );
  }
}
