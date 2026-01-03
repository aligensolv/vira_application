import 'package:socket_io_client/socket_io_client.dart';
import 'package:vira/core/config/app_constants.dart';
import 'package:vira/core/services/cache_service.dart';
import 'package:vira/core/utils/logger.dart';

class SocketManager {
  static Socket? _socket;
  static Socket get socket => _socket!;

  
  static Future<void> initialize() async {
    final token = CacheService.getString('access_token');

    final options = OptionBuilder()
      .setTransports(['websocket']);

    if (token != null && token.isNotEmpty) {
      options.setExtraHeaders({
        'Authorization': token,
      });
    }

    _socket = io(
      AppConstants.baseUrl,
      options.build(),  
    );

    _registerListeners();
  } 

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}

void _registerListeners() {
  SocketManager.socket.onConnect((_) {
    pinfo('Socket connected');
  });

  SocketManager.socket.onDisconnect((_) {
    pinfo('Socket disconnected');
  });

  SocketManager.socket.onError((error) {
    perror('Socket error: $error');
  });

  SocketManager.socket.onConnectError((error) {
    perror('Socket connection error: $error');
  });
}