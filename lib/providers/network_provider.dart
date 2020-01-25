import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkProvider {
  StreamSubscription<ConnectivityResult> _subscription;
  StreamController<ConnectivityResult> _networkConnectionStatusController;

  NetworkProvider() {
    _networkConnectionStatusController = StreamController<ConnectivityResult>();
    _invokStatusControllerListen();
  }

  StreamSubscription<ConnectivityResult> get subscription => _subscription;

  StreamController<ConnectivityResult> get networkConnectionStatus =>
      _networkConnectionStatusController;

  void _invokStatusControllerListen() async {
    _networkConnectionStatusController.sink
        .add(await Connectivity().checkConnectivity());
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _networkConnectionStatusController.sink.add(result);
    });
  }

  void disposeStreams() {
    _subscription.cancel();
    _networkConnectionStatusController.close();
  }
}
