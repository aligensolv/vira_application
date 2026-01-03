import '../../../../core/network/api_client.dart';

class BookingRemoteDataSource {
  final ApiClient _client;

  BookingRemoteDataSource(this._client);

  /// POST /bookings
  Future<void> createBooking({
    required int placeId,
    required String startTime,
    required int durationMinutes
  }) async {
    try {
      await _client.post('/bookings', data: {
        'place_id': placeId,
        'start_time': startTime,
        'requested_duration_minutes': durationMinutes,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// GET /my-bookings (Assuming an endpoint exists for user history)
  Future<List<dynamic>> getMyBookings() async {
    try {
      final response = await _client.get('/bookings/me');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  dynamic getBooking(int bookingId) async {
    try {
      final respose = await _client.get('/bookings/$bookingId');

      return respose.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  /// POST /bookings/{id}/cancel
  Future<void> cancelBooking(int id) async {
    try {
      await _client.post('/bookings/$id/cancel');
    } catch (e) {
      rethrow;
    }
  }

  // ... inside BookingRemoteDataSource
  Future<void> extendBooking({
    required int bookingId,
    required int extraMinutes,
  }) async {
    try {
      await _client.post('/bookings/$bookingId/extend', data: {
        'extra_minutes': extraMinutes,
      });
    } catch (e) {
      rethrow;
    }
  }
}