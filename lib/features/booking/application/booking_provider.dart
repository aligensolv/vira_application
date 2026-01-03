import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/data/models/booking.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../data/datasources/booking_remote_data_source.dart';
import '../data/repositories/booking_repository.dart';

// 1. Data Source
final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return BookingRemoteDataSource(client);
});

// 2. Repository
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final dataSource = ref.watch(bookingRemoteDataSourceProvider);
  return BookingRepository(dataSource);
});

// 3. User Bookings List (Future Provider for the Bookings Screen)
final myBookingsProvider = FutureProvider.autoDispose<List<Booking>>((ref) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return await repo.getMyBookings();
});

final selectedBookingProvider = Provider<Booking?>((ref) => null);

final bookingByIdProvider = Provider.family<Booking?, int>((ref, id) {
  final bookings = ref.watch(myBookingsProvider);
  return bookings.value?.firstWhere((b) => b.id == id);
});


final singleBookingProvider = FutureProvider.family.autoDispose<Booking?, int>((ref, id) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return await repo.getSingleBooking(id);
});