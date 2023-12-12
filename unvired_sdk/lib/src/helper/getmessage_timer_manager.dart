import 'dart:async';

import 'package:logger/logger.dart';

import '../authentication_service.dart';
import '../helper/settings_helper.dart';
import '../sync_engine.dart';

class GetMessageTimerManager {
  Timer? _timer;
  static final GetMessageTimerManager _getMessageTimerManager =
      GetMessageTimerManager._internal();
  GetMessageTimerManager._internal();
  factory GetMessageTimerManager() {
    return _getMessageTimerManager;
  }

  void setup() {
    _timer = null;
  }

  void startTimer() async {
    // Should we start the Timer?
    // 1. We wont if the user hasn't specified the Get Message Polling Interval.
    // 2. We wont start it if it is already running.
    // 3. We wont start if there is no Pending Request.

    // 1.
    if (_timer != null) {
      // Timer is already running.
      return;
    }
    // 2.
    // Get the Current Polling Interval.

    int interverInSec = await SettingsHelper().getFetchInterval();

    int interval = AuthenticationService().getMessageInterval();
    if (interval <= 0 && interverInSec <= 0) {
      // No Polling Interval specified.
      return;
    }

    // 3.
    if (!(await _isAnyRequestPending())) {
      // No pending messages.
      return;
    }

    if (interverInSec > 0) {
      interval = interverInSec;
    }

    _timer = new Timer.periodic(Duration(seconds: interval), (timer) {
      _callGetMessage();
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  Future<bool> _isAnyRequestPending() async {
    int sentItemsCount = await SettingsHelper().getSentItemsCount();
    return sentItemsCount > 0;
  }

  Future<void> _callGetMessage() async {
    // We will call Get Message only if there are any pending Requests.
    // If there are none, we just invalidate the Timer.
    if (await _isAnyRequestPending()) {
      Logger.logInfo("GetMessageTimerManager", "callGetMessage",
          "Timer Elapsed. Calling Get Message");
      SyncEngine().receive();
      return;
    }
    // Invalidate the Existing Timer.
    stopTimer();
  }
}
