import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/application/booking_provider.dart';
import '../../places/data/models/place.dart';
import '../data/repositories/booking_repository.dart';

enum BookingStartType { now, later }

class BookingDraftState {
  final BookingStartType startType;
  final DateTime startTime;
  final int durationMinutes;
  final double pricePerHour;
  
  BookingDraftState({
    required this.startTime,
    required this.durationMinutes,
    required this.pricePerHour,
    this.startType = BookingStartType.now
  });

  double get estimatedPrice {
    final hours = (durationMinutes / 60).ceil();
    return hours * pricePerHour;
  }

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

  BookingDraftState copyWith({
    DateTime? startTime,
    BookingStartType? type,
    int? durationMinutes,
  }) {
    return BookingDraftState(
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      pricePerHour: pricePerHour,
      startType: type ?? startType
    );
  }
}

// --- CONTROLLER ---
class BookingController extends StateNotifier<BookingDraftState> {
  final BookingRepository _repository; // Changed from ApiClient

  BookingController(
    this._repository, 
    double pricePerHour, 
    int minDuration
  ) : super(BookingDraftState(
          startTime: DateTime.now(),
          durationMinutes: minDuration,
          pricePerHour: pricePerHour,
        ));

  void setStartTime(DateTime time) {
    state = state.copyWith(startTime: time);
  }

  void setStartType(BookingStartType type) {
    state = state.copyWith(
      type: type
    );
  }

  void setDuration(int minutes) {
    state = state.copyWith(durationMinutes: minutes);
  }

  void incrementDuration() {
    final newDuration = state.durationMinutes + 15;
    if (newDuration <= 1440) {
      state = state.copyWith(durationMinutes: newDuration);
    }
  }

  void decrementDuration(int minDuration) {
    final newDuration = state.durationMinutes - 15;
    if (newDuration >= minDuration) {
      state = state.copyWith(durationMinutes: newDuration);
    }
  }

  // Submit Booking (Called from Checkout Screen)
  Future<void> submitBooking(int placeId) async {
    try {
      await _repository.createBooking(
        placeId: placeId,
        startTime: state.startTime,
        durationMinutes: state.durationMinutes
      );
    } catch (e) {
      rethrow;
    }
  }

  // Cancel booking (called from Booking details screen)
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _repository.cancelBooking(bookingId);
    } catch (e) {
      rethrow;
    }
  }
}

// --- PROVIDER ---
final bookingControllerProvider = StateNotifierProvider.autoDispose
    .family<BookingController, BookingDraftState, Place>((ref, place) {
  
  // Inject Repository instead of ApiClient
  final repository = ref.watch(bookingRepositoryProvider);
  
  return BookingController(
    repository, 
    place.pricePerHour, 
    place.minDurationMinutes
  );
});