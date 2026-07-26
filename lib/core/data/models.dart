class RecentDocument {
  const RecentDocument(this.name, this.status);
  final String name;
  final String status;

  RecentDocument copyWith({String? name, String? status}) {
    return RecentDocument(
      name ?? this.name,
      status ?? this.status,
    );
  }
}

class TrendingRisk {
  const TrendingRisk({
    required this.badge,
    required this.title,
    required this.description,
  });
  final String badge; // HIGH RISK / UPDATE / CRITICAL / MODERATE
  final String title;
  final String description;

  TrendingRisk copyWith({String? badge, String? title, String? description}) {
    return TrendingRisk(
      badge: badge ?? this.badge,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.fromBot,
    required this.text,
    this.severity,
    this.verdict,
    this.lawsCited,
    this.caseLens,
  });
  final bool fromBot;
  final String text;
  final String? severity;
  final String? verdict;
  final List<String>? lawsCited;
  final String? caseLens;

  ChatMessage copyWith({
    bool? fromBot,
    String? text,
    String? severity,
    String? verdict,
    List<String>? lawsCited,
    String? caseLens,
  }) {
    return ChatMessage(
      fromBot: fromBot ?? this.fromBot,
      text: text ?? this.text,
      severity: severity ?? this.severity,
      verdict: verdict ?? this.verdict,
      lawsCited: lawsCited ?? this.lawsCited,
      caseLens: caseLens ?? this.caseLens,
    );
  }
}

class EmergencyService {
  const EmergencyService({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.number,
    required this.keywords,
    required this.emergencyGuidance,
    required this.whenToUse,
    this.website,
    this.address,
  });

  final String id;
  final String title;
  final String description;

  /// Category used for filter chips, e.g. "Emergency", "Women Safety".
  final String category;

  final String number;
  final String? website;
  final String? address;

  /// List of search keywords (lower-case).
  final List<String> keywords;

  /// Step-by-step guidance shown on the detail screen.
  final String emergencyGuidance;

  /// Short paragraph on when to use this service.
  final String whenToUse;

  EmergencyService copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? number,
    String? website,
    String? address,
    List<String>? keywords,
    String? emergencyGuidance,
    String? whenToUse,
  }) {
    return EmergencyService(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      number: number ?? this.number,
      website: website ?? this.website,
      address: address ?? this.address,
      keywords: keywords ?? this.keywords,
      emergencyGuidance: emergencyGuidance ?? this.emergencyGuidance,
      whenToUse: whenToUse ?? this.whenToUse,
    );
  }
}
