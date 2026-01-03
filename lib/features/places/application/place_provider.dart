import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/places/data/datasource/place_remote_data_source.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../data/models/place.dart';
import '../data/repositories/place_repository.dart';

// 1. Dependency Injection
final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final dataSource = PlaceRemoteDataSource(client);
  return PlaceRepository(dataSource);
});

// 2. Fetch All Places (e.g. for "Nearby" in Home)
final placesProvider = FutureProvider<List<Place>>((ref) async {
  final repo = ref.watch(placeRepositoryProvider);
  return await repo.getPlaces();
});

// 3. Fetch Places by Region (Family Provider)
// Usage: ref.watch(placesByRegionProvider(regionId))
final placesByRegionProvider = FutureProvider.family<List<Place>, int>((ref, regionId) async {
  final repo = ref.watch(placeRepositoryProvider);
  return await repo.getPlaces(regionId: regionId);
});


final selectedPlaceProvider = Provider<Place?>((ref) => null);

final placeByIdProvider = Provider.family<Place?, int>((ref, id) {
  final places = ref.watch(placesProvider);
  return places.value?.firstWhere((p) => p.id == id);
});
