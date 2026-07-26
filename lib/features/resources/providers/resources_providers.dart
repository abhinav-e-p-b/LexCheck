import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/data/models.dart';
import '../data/resources_repository.dart';

// ─── Repository ───────────────────────────────────────────────────────────────

final resourcesRepositoryProvider = Provider<ResourcesRepository>(
  (ref) => const ResourcesRepository(),
);

// ─── Search & Filter state ────────────────────────────────────────────────────

final resourceSearchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Derived provider that combines search query + category filter.
final filteredResourcesProvider = Provider<List<EmergencyService>>((ref) {
  final repo = ref.watch(resourcesRepositoryProvider);
  final query = ref.watch(resourceSearchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repo.searchAndFilter(query: query, category: category);
});

// ─── Nearby services / Location ───────────────────────────────────────────────

/// Represents the result of a location request.
sealed class LocationResult {
  const LocationResult();
}

class LocationSuccess extends LocationResult {
  const LocationSuccess(this.position);
  final Position position;
}

class LocationDenied extends LocationResult {
  const LocationDenied(this.message);
  final String message;
}

class LocationUnavailable extends LocationResult {
  const LocationUnavailable(this.message);
  final String message;
}

/// Requests the device's current GPS position, handling permissions gracefully.
Future<LocationResult> getCurrentLocation() async {
  LocationPermission permission;

  // Check if location services are enabled on the device.
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return const LocationUnavailable(
        'Location services are disabled. Please enable GPS in device settings.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return const LocationDenied(
          'Location permission denied. Enable it in app settings to use this feature.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return const LocationDenied(
        'Location permission is permanently denied. '
        'Go to app settings to grant permission.');
  }

  try {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return LocationSuccess(position);
  } catch (e) {
    return LocationUnavailable('Could not determine location: $e');
  }
}

/// Definition of a "nearby service" category – makes it easy to add more later.
class NearbyServiceType {
  const NearbyServiceType({
    required this.label,
    required this.mapsQuery,
    required this.icon,
  });

  final String label;

  /// The search query appended to Google Maps, e.g. "police station near me".
  final String mapsQuery;

  final String icon; // Emoji or short label shown on button
}

const nearbyServiceTypes = [
  NearbyServiceType(
    label: 'Police Station',
    mapsQuery: 'police station',
    icon: '🚔',
  ),
  NearbyServiceType(
    label: 'Hospital',
    mapsQuery: 'hospital emergency',
    icon: '🏥',
  ),
  NearbyServiceType(
    label: 'Legal Aid Centre',
    mapsQuery: 'legal aid centre',
    icon: '⚖️',
  ),
];
