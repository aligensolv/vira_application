import 'package:vira/core/realtime/socket.dart';
import 'package:vira/core/utils/logger.dart';

class PlaceRoom {
  static const String _placePrefix = 'place_';

  static void joinPlace(int placeId) {
    final roomName = '$_placePrefix$placeId';
    SocketManager.socket.emit('join_place', roomName);
    pinfo('Joined place room: $roomName');
  }

  static void leavePlace(int placeId) {
    final roomName = '$_placePrefix$placeId';
    SocketManager.socket.emit('leave_place', roomName);
    pinfo('Left place room: $roomName');
  }

  static void onPlaceUpdate(Function(dynamic) callback) {
    SocketManager.socket.on('place_update', callback);
  }

  static void offPlaceUpdate() {
    SocketManager.socket.off('place_update');
  }
}