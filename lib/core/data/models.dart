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
  const ChatMessage({required this.fromBot, required this.text});
  final bool fromBot;
  final String text;

  ChatMessage copyWith({bool? fromBot, String? text}) {
    return ChatMessage(
      fromBot: fromBot ?? this.fromBot,
      text: text ?? this.text,
    );
  }
}

class EmergencyService {
  const EmergencyService({
    required this.id,
    required this.title,
    required this.description,
    required this.number,
  });
  final String id;
  final String title;
  final String description;
  final String number;

  EmergencyService copyWith({String? id, String? title, String? description, String? number}) {
    return EmergencyService(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      number: number ?? this.number,
    );
  }
}
