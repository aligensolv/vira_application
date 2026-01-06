import 'package:vira/features/profile/datasources/profile_remote_data_source.dart';

import '../models/user_metrics.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  Future<UserMetrics> getUserMetrics(int userId) async {
    final data = await _remoteDataSource.getUserMetrics(userId);
    return UserMetrics.fromJson(data);
  }
}