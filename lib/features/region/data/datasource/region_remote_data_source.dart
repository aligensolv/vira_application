import '../../../../core/network/api_client.dart';

class RegionRemoteDataSource {
  final ApiClient _client;

  RegionRemoteDataSource(this._client);

  Future<List<dynamic>> getRegions() async {
    try {
      final response = await _client.get('regions');
      return response.data['data']; 
    } catch (e) {
      rethrow;
    }
  }
}