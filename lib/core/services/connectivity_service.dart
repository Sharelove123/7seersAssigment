import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final connectionStatusProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectionChanged;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onConnectionChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      if (results.isEmpty) return false;
      return !results.contains(ConnectivityResult.none);
    });
  }

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) return false;
    return !results.contains(ConnectivityResult.none);
  }
}
