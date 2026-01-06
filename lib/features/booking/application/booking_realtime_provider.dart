import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/realtime/socket.dart';
import 'package:vira/core/realtime/socket_events.dart';
import 'package:vira/core/utils/logger.dart';
import 'package:vira/features/booking/application/booking_provider.dart';
import 'package:vira/features/booking/data/models/booking.dart';

final bookingRealtimeProvider = Provider<void>((ref) {

  SocketManager.socket.on(SocketEvents.booking.created, (data) {
    pinfo(data);
    final booking = Booking.fromJson(data);
    ref.read(myBookingsProvider.notifier).upsert(booking);
  });

  SocketManager.socket.on(SocketEvents.booking.completed, (data) {
    ref.read(myBookingsProvider.notifier).updateStatus(data['id'], BookingStatus.completed);
  });

  SocketManager.socket.on(SocketEvents.booking.extended, (data) {
    final booking = Booking.fromJson(data);
    pwarnings(booking);
    ref.read(myBookingsProvider.notifier).upsert(booking);
  });
  
  SocketManager.socket.on(SocketEvents.booking.activated, (data) {
    ref.read(myBookingsProvider.notifier).updateStatus(data['id'], BookingStatus.active);
  });
  
  SocketManager.socket.on(SocketEvents.booking.cancelled, (data) {
    ref.read(myBookingsProvider.notifier).updateStatus(data['id'], BookingStatus.cancelled);
  });

  

  // SocketManager.socket.on('booking.deleted', (data) {
  //   ref.read(myBookingsProvider.notifier).remove(data);
  // });

  ref.onDispose(() {
    SocketManager.socket.off(SocketEvents.booking.created);
    SocketManager.socket.off(SocketEvents.booking.completed);
    SocketManager.socket.off(SocketEvents.booking.extended);
    SocketManager.socket.off(SocketEvents.booking.activated);
    // SocketManager.socket.off('booking.deleted');
  });
});
