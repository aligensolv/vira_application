import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/profile/datasources/profile_remote_data_source.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../../auth/application/auth_controller.dart';
import '../data/models/user_metrics.dart';
import '../data/repositories/profile_repository.dart';

// 1. Datasource Provider
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return ProfileRemoteDataSource(client);
});

// 2. Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepository(dataSource);
});

// 3. User Metrics Provider
final userMetricsProvider = FutureProvider.autoDispose<UserMetrics>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  
  // Get current User ID from Auth State
  final authState = ref.watch(authControllerProvider);
  final user = authState.value;

  if (user == null) {
    throw Exception("User not logged in");
  }

  return await repo.getUserMetrics(user.id);
});