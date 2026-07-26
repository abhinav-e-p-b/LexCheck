import '../../../core/data/mock_data.dart';
import '../../../core/data/models.dart';

/// Repository that owns all read operations for [EmergencyService] data.
/// UI and providers should use this class rather than accessing [MockData] directly.
class ResourcesRepository {
  const ResourcesRepository();

  /// All available resources.
  List<EmergencyService> getAll() => MockData.emergencyServices;

  /// Resources filtered by [category]. Pass null to get all.
  List<EmergencyService> filterByCategory(String? category) {
    if (category == null) return getAll();
    return MockData.emergencyServices
        .where((s) => s.category == category)
        .toList();
  }

  /// Full-text search across title, description, keywords, and phone number.
  List<EmergencyService> search(String query) {
    if (query.isEmpty) return getAll();
    final q = query.toLowerCase().trim();
    return MockData.emergencyServices.where((s) {
      return s.title.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q) ||
          s.number.contains(q) ||
          s.keywords.any((k) => k.contains(q));
    }).toList();
  }

  /// Combined search + category filter.
  List<EmergencyService> searchAndFilter({
    required String query,
    String? category,
  }) {
    var results = query.isEmpty ? getAll() : search(query);
    if (category != null) {
      results = results.where((s) => s.category == category).toList();
    }
    return results;
  }

  /// Find a single resource by ID.
  EmergencyService? findById(String id) {
    try {
      return MockData.emergencyServices.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// All unique categories in the order defined in [MockData.resourceCategories].
  List<String> getCategories() => MockData.resourceCategories;

  /// Resources whose IDs are in [ids], preserving [ids] order.
  List<EmergencyService> getByIds(List<String> ids) {
    return ids
        .map(findById)
        .whereType<EmergencyService>()
        .toList();
  }
}
