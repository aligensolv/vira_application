import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  static final NetworkChecker _instance = NetworkChecker._internal();

  factory NetworkChecker() => _instance;

  NetworkChecker._internal();

  final Connectivity _connectivity = Connectivity();

  /// Checks if the device has an active internet connection.
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.any((element) => element == ConnectivityResult.none) || connectivityResult.isEmpty) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Continuously listens for network status changes.
  Stream<bool> onStatusChange({Duration interval = const Duration(seconds: 5)}) async* {
    bool? previousStatus;
    await for (final _ in _connectivity.onConnectivityChanged) {
      final currentStatus = await isConnected;
      if (previousStatus == null || previousStatus != currentStatus) {
        yield currentStatus;
        previousStatus = currentStatus;
      }
    }
  }
}

