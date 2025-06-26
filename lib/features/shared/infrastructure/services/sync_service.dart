// connectivity_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

enum ConnectivityStatus { online, offline }

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
  (ref) => ConnectivityNotifier(),
);

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityNotifier() : super(ConnectivityStatus.offline) {
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result); // Aquí también es una lista
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final last = results.last;
    if (last == ConnectivityResult.none) {
      state = ConnectivityStatus.offline;
    } else {
      state = ConnectivityStatus.online;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
