import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vira/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vira/features/auth/data/models/user.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

// 1. Shared Prefs Provider (Needs override in main.dart)
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// 2. Data Source Provider
final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(apiClientProvider));
});

// 3. Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authDataSourceProvider)
  );
});

// 4. Controller Provider (State)
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});