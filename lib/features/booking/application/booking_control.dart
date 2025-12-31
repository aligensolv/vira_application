import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/shared/providers/api_client.dart';
import '../../../../core/network/api_client.dart';
import '../../places/data/models/place.dart';

// --- STATE MODEL ---
class BookingDraftState {
  final DateTime startTime;
  final int durationMinutes;
  final double pricePerHour;
  
  BookingDraftState({
    required this.startTime,
    required this.durationMinutes,
    required this.pricePerHour,
  });

  // Business Rule: Price = ceil(hours) * rate
  double get estimatedPrice {
    final hours = (durationMinutes / 60).ceil();
    return hours * pricePerHour;
  }

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

  BookingDraftState copyWith({
    DateTime? startTime,
    int? durationMinutes,
  }) {
    return BookingDraftState(
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      pricePerHour: this.pricePerHour,
    );
  }
}

// --- CONTROLLER ---
class BookingController extends StateNotifier<BookingDraftState> {
  final ApiClient _apiClient;

  BookingController(this._apiClient, double pricePerHour, int minDuration) 
      : super(BookingDraftState(
          startTime: DateTime.now(), // Default: Now
          durationMinutes: minDuration,
          pricePerHour: pricePerHour,
        ));

  void setStartTime(DateTime time) {
    state = state.copyWith(startTime: time);
  }

  void setDuration(int minutes) {
    state = state.copyWith(durationMinutes: minutes);
  }

  Future<void> submitBooking(int placeId) async {
    try {
      // API Call
      await _apiClient.post('/bookings', data: {
        'place_id': placeId,
        'start_time': state.startTime.toIso8601String(),
        'duration_minutes': state.durationMinutes,
      });
    } catch (e) {
      rethrow;
    }
  }

  void incrementDuration() {
    // Step: 15 minutes
    final newDuration = state.durationMinutes + 15;
    // Cap at 24 hours (1440 min) or simpler logic
    if (newDuration <= 1440) {
      state = state.copyWith(durationMinutes: newDuration);
    }
  }

  void decrementDuration(int minDuration) {
    // Step: 15 minutes, but don't go below place minimum
    final newDuration = state.durationMinutes - 15;
    if (newDuration >= minDuration) {
      state = state.copyWith(durationMinutes: newDuration);
    }
  }
}

// --- PROVIDER ---
// We use .family to initialize it with specific Place data
final bookingControllerProvider = StateNotifierProvider.autoDispose
    .family<BookingController, BookingDraftState, Place>((ref, place) {
  final client = ref.watch(apiClientProvider);
  return BookingController(
    client, 
    place.pricePerHour, 
    place.minDurationMinutes
  );
});