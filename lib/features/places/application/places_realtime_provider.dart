import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/realtime/socket.dart';
import 'package:vira/core/utils/logger.dart';
import 'package:vira/features/places/application/place_provider.dart';
import 'package:vira/features/places/data/models/place.dart';

final placesRealtimeProvider = Provider<void>((ref) {

  SocketManager.socket.on('place.created', (data) {
    pinfo(data);
    final place = Place.fromJson(data);
    ref.read(placesProvider.notifier).upsert(place);
  });

  SocketManager.socket.on('place.updated', (data) {
    final place = Place.fromJson(data);
    ref.read(placesProvider.notifier).upsert(place);
  });

  SocketManager.socket.on('place.deleted', (data) {
    ref.read(placesProvider.notifier).remove(data);
  });

  ref.onDispose(() {
    SocketManager.socket.off('place.created');
    SocketManager.socket.off('place.updated');
    SocketManager.socket.off('place.deleted');
  });
});
