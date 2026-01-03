import 'package:vira/features/booking/data/models/booking.dart';

import '../datasources/booking_remote_data_source.dart';

class BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepository(this._remoteDataSource);

  Future<void> createBooking({
    required int placeId,
    required DateTime startTime,
    required int durationMinutes
  }) async {
    await _remoteDataSource.createBooking(
      placeId: placeId,
      startTime: startTime.toUtc().toIso8601String(),
      durationMinutes: durationMinutes
    );
  }

  Future<List<Booking>> getMyBookings() async {
    final data = await _remoteDataSource.getMyBookings();

    return data.map((json) => Booking.fromJson(json)).toList();
  }

  Future<Booking> getSingleBooking(int bookingId) async{
    final data = await _remoteDataSource.getBooking(bookingId);

    return Booking.fromJson(data);
  }

  Future<void> cancelBooking(int bookingId) async {
    await _remoteDataSource.cancelBooking(bookingId);
  }

  Future<void> extendBooking(int bookingId, int extraMinutes) async {
  await _remoteDataSource.extendBooking(
      bookingId: bookingId, 
      extraMinutes: extraMinutes
    );
  }
}