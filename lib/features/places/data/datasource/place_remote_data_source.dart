import '../../../../core/network/api_client.dart';

class PlaceRemoteDataSource {
  final ApiClient _client;

  PlaceRemoteDataSource(this._client);

  /// Fetches places. If [regionId] is provided, filters by region.
  Future<List<dynamic>> getPlaces({int? regionId}) async {
    try {
      final Map<String, dynamic>? queryParams = 
          regionId != null ? {'region_id': regionId} : null;

      final response = await _client.get('/places/active', queryParameters: queryParams);
      return response.data['data']; 
    } catch (e) {
      rethrow;
    }
  }
}