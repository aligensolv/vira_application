import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/auth/data/models/user.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository.dart';

// 1. Dependency Injection for Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = AuthRemoteDataSource(apiClient);
  return AuthRepository(remoteDataSource);
});

// 2. Auth State (AsyncValue<User?> handles loading, error, data)
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});

// 3. The Controller Logic
class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(const AsyncValue.data(null)) {
    _checkCurrentUser();
  }

  // Load user from storage on app start
  void _checkCurrentUser() {
    final user = _repo.getCurrentUser();
    if (user != null) {
      state = AsyncValue.data(user);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.register(name, email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}