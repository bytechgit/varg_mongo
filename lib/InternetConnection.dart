import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class InternetConnection {
  static final InternetConnection _instance = InternetConnection._internal();
  static bool isDeviceConnected = false;
  bool _snackBarStatus = false;
  OverlaySupportEntry? _message = null;
  var _subscription;

  factory InternetConnection() {
    return _instance;
  }

  InternetConnection._internal() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      testConnection();
    });
  }

  Future<void> testConnection() async {
    if (!isDeviceConnected && !_snackBarStatus) {
      _message = showSimpleNotification(const Text("Nemate pristup internetu!"),
          background: const Color.fromRGBO(50, 50, 50, 0.9),
          duration: const Duration(seconds: 30),
          autoDismiss: false);
      _snackBarStatus = true;
    } else if (isDeviceConnected && _snackBarStatus) {
      _message?.dismiss(animate: false);
      _message = showSimpleNotification(
          const Text("Konekcija je uspostavljena!"),
          background: Colors.green,
          duration: const Duration(seconds: 2),
          autoDismiss: true);
      _snackBarStatus = false;
    }
  }
}
