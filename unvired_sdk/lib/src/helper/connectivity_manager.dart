import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../helper/service_constants.dart';
import '../helper/event_handler_constants.dart';
import '../helper/http_connection.dart';
import '../notification_center/dart_notification_center.dart';

class ConnectivityManager {
  static final ConnectivityManager _connectivityManager =
      ConnectivityManager._internal();
  ConnectivityManager._internal();
  factory ConnectivityManager() {
    return _connectivityManager;
  }
  int _delayInSeconds = 2;
  int _exponentialValue = 0;
  bool _hasConnection = false;
  bool _isConnectionCheckRunning = false;
  bool isDownloadMessageListening = false;
  bool isSyncEngineListening = false;
  bool isOutboxListening = false;

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  //The test to actually see if there is a connection
  Future<bool> waitForConnection() async {
    Logger.logDebug("ConnectivityManager", "waitForConnection",
        "Waiting for internet connection");

    bool previousConnection = _hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _hasConnection = true;
        Logger.logDebug(
            "ConnectivityManager", "waitForConnection", "Internet active");
      } else {
        _hasConnection = false;
      }
    } on SocketException catch (_) {
      _hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (_hasConnection) {
      final bool isServerReachable = await HTTPConnection.isServerReachable();
      DartNotificationCenter.post(
          channel: EventNameConnectionStatus,
          options: (isServerReachable)
              ? "OnlineServerReachable"
              : "OnlineServerNotReachable");
    }

    if (!_hasConnection) {
      int expValue = pow(_delayInSeconds, _exponentialValue).toInt();
      await Future.delayed(Duration(milliseconds: expValue * 1000));
      _exponentialValue++;
      if (_exponentialValue == 9) {
        _exponentialValue = 0;
      }
      return await waitForConnection();
    }
    _exponentialValue = 0;
    DartNotificationCenter.post(
        channel: EventNameConnectionStatus, options: online);
    return true;
  }

  notifyConnection() async {
    if (!_isConnectionCheckRunning) {
      _isConnectionCheckRunning = true;
      bool connection = await waitForConnection();
      _isConnectionCheckRunning = false;
      if (connection) {
        DartNotificationCenter.post(
            channel: EventNameConnectionStatus, options: online);
      } else {
        DartNotificationCenter.post(
            channel: EventNameConnectionStatus, options: offline);
      }
    }
  }
}
