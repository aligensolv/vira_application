import 'package:socket_io_client/socket_io_client.dart';
import 'package:vira/core/config/app_constants.dart';
import 'package:vira/core/services/cache_service.dart';
import 'package:vira/core/utils/logger.dart';

class SocketManager {
  static late Socket _socket;
  
  static Future<void> initialize() async {
    final token = CacheService.getString('access_token');

    _socket = io(
      AppConstants.baseUrl,
      OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders({
          'Authorization': token,
        })
        .build(),
    );

    _socket.onConnect((_) {
      pinfo('Socket connected');
    });

    _socket.onDisconnect((_) {
      pinfo('Socket disconnected');
    });

    _socket.onError((error) {
      perror('Socket error: $error');
    });

    _socket.onConnectError((error) {
      perror('Socket connection error: $error');
    });
  }
  
  static Socket get socket => _socket;
}