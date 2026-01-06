import '../../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSource(this._client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.post('auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _client.post('auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _client.post('/auth/forgot-password', data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      await _client.post('/auth/verify-otp', data: {'email': email, 'otp': otp});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _client.post('/auth/reset-password', data: {
        'email': email,
        'otp': otp,
        'password': newPassword,
        'password_confirmation': newPassword,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      await _client.post('/auth/resend-otp', data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }
}