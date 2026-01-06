import '../../../../core/network/api_client.dart';

class ProfileRemoteDataSource {
  final ApiClient _client;

  ProfileRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getUserMetrics(int userId) async {
    try {
      final response = await _client.get('/users/$userId/metrics');
      // Based on your JSON: { "data": { ... } }
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}