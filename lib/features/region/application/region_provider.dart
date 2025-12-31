import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/region/data/datasource/region_remote_data_source.dart';
import 'package:vira/features/region/data/models/region.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../data/repositories/region_repository.dart';

// 1. Repository Provider
final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final remoteDataSource = RegionRemoteDataSource(client);
  return RegionRepository(remoteDataSource);
});

// 2. Regions Logic (FutureProvider is best for fetching lists)
final regionsProvider = FutureProvider<List<Region>>((ref) async {
  final repository = ref.watch(regionRepositoryProvider);
  return await repository.getRegions();
});