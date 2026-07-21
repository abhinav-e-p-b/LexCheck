import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../data/models.dart';

final recentDocumentsProvider = NotifierProvider<RecentDocumentsNotifier, List<RecentDocument>>(RecentDocumentsNotifier.new);

class RecentDocumentsNotifier extends Notifier<List<RecentDocument>> {
  @override
  List<RecentDocument> build() {
    return List.from(MockData.recentDocuments);
  }

  void addDocument(RecentDocument doc) {
    state = [doc, ...state];
  }

  void clear() {
    state = [];
  }
}

final trendingRisksProvider = Provider<List<TrendingRisk>>((ref) {
  return MockData.trendingRisks;
});

final highRiskAlertsDarkProvider = Provider<List<TrendingRisk>>((ref) {
  return MockData.highRiskAlertsDark;
});

final chatThreadProvider = NotifierProvider<ChatThreadNotifier, List<ChatMessage>>(ChatThreadNotifier.new);

class ChatThreadNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return List.from(MockData.chatThread);
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}

final emergencyServicesProvider = Provider<List<EmergencyService>>((ref) {
  return MockData.emergencyServices;
});

final checklistProvider = NotifierProvider<ChecklistNotifier, Map<int, bool>>(ChecklistNotifier.new);

class ChecklistNotifier extends Notifier<Map<int, bool>> {
  @override
  Map<int, bool> build() {
    return {0: false, 1: false, 2: true, 3: false};
  }

  void toggle(int index, bool value) {
    final newState = Map<int, bool>.from(state);
    newState[index] = value;
    state = newState;
  }
}

final profileSettingsProvider = NotifierProvider<ProfileSettingsNotifier, ProfileSettings>(ProfileSettingsNotifier.new);

class ProfileSettings {
  final bool mechanicalFeedback;
  final bool hapticOverlays;
  final bool autoArchive;

  const ProfileSettings({
    required this.mechanicalFeedback,
    required this.hapticOverlays,
    required this.autoArchive,
  });

  ProfileSettings copyWith({
    bool? mechanicalFeedback,
    bool? hapticOverlays,
    bool? autoArchive,
  }) {
    return ProfileSettings(
      mechanicalFeedback: mechanicalFeedback ?? this.mechanicalFeedback,
      hapticOverlays: hapticOverlays ?? this.hapticOverlays,
      autoArchive: autoArchive ?? this.autoArchive,
    );
  }
}

class ProfileSettingsNotifier extends Notifier<ProfileSettings> {
  @override
  ProfileSettings build() {
    return const ProfileSettings(
      mechanicalFeedback: false,
      hapticOverlays: true,
      autoArchive: false,
    );
  }

  void toggleMechanicalFeedback(bool value) {
    state = state.copyWith(mechanicalFeedback: value);
  }

  void toggleHapticOverlays(bool value) {
    state = state.copyWith(hapticOverlays: value);
  }

  void toggleAutoArchive(bool value) {
    state = state.copyWith(autoArchive: value);
  }
}
