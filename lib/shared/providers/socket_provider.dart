// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart';
// import 'socket_client.dart';
// import '../auth/auth_provider.dart'; // where token comes from

// final socketProvider = Provider<Socket>((ref) {
//   final client = SocketClient();

//   final socket = client.connect(token: token);

//   socket.onConnect((_) {
//     print('🟢 Socket connected');
//   });

//   socket.onDisconnect((_) {
//     print('🔴 Socket disconnected');
//   });

//   socket.onConnectError((e) {
//     print('❌ Socket connect error: $e');
//   });

//   socket.onError((e) {
//     print('❌ Socket error: $e');
//   });

//   ref.onDispose(() {
//     client.disconnect();
//   });

//   return socket;
// });
