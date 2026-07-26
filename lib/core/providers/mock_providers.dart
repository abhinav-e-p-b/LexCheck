import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data.dart';
import '../data/models.dart';

// ─── SharedPreferences singleton ──────────────────────────────────────────────

/// Initialised in main.dart before runApp.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not yet initialised');
});

// ─── Home / Chat providers ────────────────────────────────────────────────────

final recentDocumentsProvider =
    NotifierProvider<RecentDocumentsNotifier, List<RecentDocument>>(
        RecentDocumentsNotifier.new);

class RecentDocumentsNotifier extends Notifier<List<RecentDocument>> {
  @override
  List<RecentDocument> build() => List.from(MockData.recentDocuments);

  void addDocument(RecentDocument doc) => state = [doc, ...state];
  void clear() => state = [];
}

final trendingRisksProvider = Provider<List<TrendingRisk>>(
    (ref) => MockData.trendingRisks);

final highRiskAlertsDarkProvider = Provider<List<TrendingRisk>>(
    (ref) => MockData.highRiskAlertsDark);

final chatThreadProvider =
    NotifierProvider<ChatThreadNotifier, List<ChatMessage>>(
        ChatThreadNotifier.new);

class ChatThreadNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => List.from(MockData.chatThread);

  void addMessage(ChatMessage message) => state = [...state, message];
}

// ─── Resources – Emergency services ──────────────────────────────────────────

final emergencyServicesProvider = Provider<List<EmergencyService>>(
    (ref) => MockData.emergencyServices);

// ─── Resources – Checklist ────────────────────────────────────────────────────

const _kChecklistPrefix = 'checklist_';

final checklistProvider =
    NotifierProvider<ChecklistNotifier, Map<int, bool>>(ChecklistNotifier.new);

class ChecklistNotifier extends Notifier<Map<int, bool>> {
  static const _count = 4;

  @override
  Map<int, bool> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return {
      for (var i = 0; i < _count; i++)
        i: prefs.getBool('$_kChecklistPrefix$i') ?? false,
    };
  }

  void toggle(int index, bool value) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool('$_kChecklistPrefix$index', value);
    state = Map.from(state)..[index] = value;
  }

  void resetAll() {
    final prefs = ref.read(sharedPreferencesProvider);
    for (var i = 0; i < _count; i++) {
      prefs.setBool('$_kChecklistPrefix$i', false);
    }
    state = {for (var i = 0; i < _count; i++) i: false};
  }
}

// ─── Resources – Favourites ───────────────────────────────────────────────────

const _kFavouritesKey = 'resource_favourites';

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getStringList(_kFavouritesKey) ?? [];
    return saved.toSet();
  }

  void toggle(String resourceId) {
    final prefs = ref.read(sharedPreferencesProvider);
    final next = Set<String>.from(state);
    if (next.contains(resourceId)) {
      next.remove(resourceId);
    } else {
      next.add(resourceId);
    }
    prefs.setStringList(_kFavouritesKey, next.toList());
    state = next;
  }

  bool isFavorite(String resourceId) => state.contains(resourceId);
}

// ─── Resources – Recently Contacted ──────────────────────────────────────────

const _kRecentlyContactedKey = 'recently_contacted';
const _kRecentlyContactedMax = 5;

final recentlyContactedProvider =
    NotifierProvider<RecentlyContactedNotifier, List<String>>(
        RecentlyContactedNotifier.new);

class RecentlyContactedNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getStringList(_kRecentlyContactedKey) ?? [];
  }

  void add(String resourceId) {
    final prefs = ref.read(sharedPreferencesProvider);
    final next = [
      resourceId,
      ...state.where((id) => id != resourceId),
    ].take(_kRecentlyContactedMax).toList();
    prefs.setStringList(_kRecentlyContactedKey, next);
    state = next;
  }
}

// ─── Profile – App Settings ───────────────────────────────────────────────────

const _kSoundEffects = 'setting_sound_effects';
const _kHapticFeedback = 'setting_haptic_feedback';

final profileSettingsProvider =
    NotifierProvider<ProfileSettingsNotifier, ProfileSettings>(
        ProfileSettingsNotifier.new);

class ProfileSettings {
  final bool soundEffects;
  final bool hapticFeedback;

  const ProfileSettings({
    required this.soundEffects,
    required this.hapticFeedback,
  });

  ProfileSettings copyWith({bool? soundEffects, bool? hapticFeedback}) {
    return ProfileSettings(
      soundEffects: soundEffects ?? this.soundEffects,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }
}

class ProfileSettingsNotifier extends Notifier<ProfileSettings> {
  @override
  ProfileSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return ProfileSettings(
      soundEffects: prefs.getBool(_kSoundEffects) ?? false,
      hapticFeedback: prefs.getBool(_kHapticFeedback) ?? true,
    );
  }

  void toggleSoundEffects(bool value) {
    ref.read(sharedPreferencesProvider).setBool(_kSoundEffects, value);
    state = state.copyWith(soundEffects: value);
  }

  void toggleHapticFeedback(bool value) {
    ref.read(sharedPreferencesProvider).setBool(_kHapticFeedback, value);
    state = state.copyWith(hapticFeedback: value);
  }
}
