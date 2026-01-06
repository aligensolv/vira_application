import 'dart:convert';
import 'package:vira/core/services/cache_service.dart';
import 'package:vira/features/auth/data/models/user.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  static const String _userKey = 'user';
  static const String _tokenKey = 'access_token';

  AuthRepository(this._remoteDataSource);

  Future<User> login(String email, String password) async {
    final data = await _remoteDataSource.login(email, password);
    return _handleAuthSuccess(data);
  }

  Future<User> register(String name, String email, String password) async {
    final data = await _remoteDataSource.register(name, email, password);
    return _handleAuthSuccess(data);
  }

  User _handleAuthSuccess(Map<String, dynamic> data) {
    final token = data['access_token'];
    final userMap = data['user'];
    
    // Add access_token to user model for internal usage if needed
    userMap['access_token'] = token; 
    final user = User.fromJson(userMap);

    CacheService.setString(_tokenKey, token);
    CacheService.setString(_userKey, jsonEncode(user.toJson()));
    
    return user;
  }

  User? getCurrentUser() {
    final userStr = CacheService.getString(_userKey);
    if (userStr == null) return null;
    return User.fromJson(jsonDecode(userStr));
  }

  Future<void> logout() async {
    await CacheService.remove(_userKey);
    await CacheService.remove(_tokenKey);
  }

  Future<void> forgotPassword(String email) async {
    await _remoteDataSource.forgotPassword(email);
  }

  Future<void> verifyOtp(String email, String otp) async {
    await _remoteDataSource.verifyOtp(email, otp);
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    await _remoteDataSource.resetPassword(
      email: email, 
      otp: otp, 
      newPassword: newPassword
    );
  }

  Future<void> resendOtp(String email) async {
    await _remoteDataSource.resendOtp(email);
  }
}