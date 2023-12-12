library logger;

import 'dart:developer';
import 'dart:io';


import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


enum LogLevel { important, error, debug }

/// A Calculator.
class Logger {
  static LogLevel defaultLevel = LogLevel.error;
  static bool isConnectedToDebugger = false;
  static String logFileName = "log.txt";
  static String backupLogFileName = "log_backup.txt";
  static String webLogString = "";

  static String? logPath;

  static void initialize(String path){
    logPath = path;
  }

  // Private functions
  static Future<void> _loggerWithLevel(LogLevel level, String sourceClass,
      String sourceMethod, String message) async {
    if(kIsWeb){
      log("$level - $sourceClass - $sourceMethod - $message");
      return;
    }
    if(logPath==null){
      log('Logger is not initialized, Please initialize Logger first...');
      throw('Logger is not initialized, Please initialize Logger first...');
    }
    if ((defaultLevel == LogLevel.error && (level == LogLevel.debug || level == LogLevel.important)) || (defaultLevel == LogLevel.important && level == LogLevel.debug)) {
      return;
    }
    // Local Format
    DateTime currentDate = new DateTime.now();
    String dateString =
        DateFormat('dd-MM-yyyy HH:mm:ss.SSS').format(currentDate);

    // UTC Format
    DateTime dateUtc = DateTime.now().toUtc();
    String utcDateString =
        DateFormat('dd-MM-yyyy HH:mm:ss.SSS').format(dateUtc);

    String data =
        "$dateString | UTC:$utcDateString | ${_getStringFromLevel(level)} | $sourceClass | $sourceMethod | $message\n";

    // if ([LoginParameters sharedParameters].enableOnlineLogging) {
    //     // Prefix UserName to Data.
    //     NSString *userName = [[UserSettingsManager sharedInstance] getServerUserIdWithError:NULL];
    //     if (userName == nil) {
    //         userName = @"NEW_USER";
    //     }
    //     [[LELog sharedInstance] log:[NSString stringWithFormat:@"USER: %@ | %@", userName, data]];
    // }

    if (level == LogLevel.error) {
      // Extra Line for LogLevel ERROR, so that it stands out. To Add Emoji's Just Press 'control + command + space' over the cursor
      data = "⭕️⭕️⭕️$data";
    }
    await _createMemo(data);
  }

  static Future<void> _createMemo(String msg) async {
    try {
      if (isConnectedToDebugger) {
        // Log only if app is running or App is running in Debug mode.
        print(msg);
      }
      if(kIsWeb){
        webLogString+=msg;
        return;
      }
      String fileUrl = await getLogFileURL();
      File file = File(fileUrl);
      int length = 0;
      if (file.existsSync()) {
        length = await file.length();
      }
      if (length >= 10000000) {
        String backupFileUrl = await getBackupLogFileURL();
        await file.copy(backupFileUrl);
        await file.writeAsString(msg);
      } else {
        await file.writeAsString(msg, mode: FileMode.append);
      }
      print("$msg");
    } catch (e) {
      print("⭕️⭕️⭕️ERROR while writing to Log file: $e");
    }
  }

  static String _getStringFromLevel(LogLevel value) {
    switch (value) {
      case LogLevel.important:
        return "IMPORTANT";
        break;
      case LogLevel.error:
        return "ERROR";
        break;
      case LogLevel.debug:
        return "DEBUG";
        break;
      default:
        break;
    }
    return "";
  }

  static Future<String?> _directoryLocation() async {

    return logPath;
  }

  // Public functions
  // Returns the file name of the log file which is stored in Documents Directory.
  String getLogfileName() {
    return logFileName;
  }

  // Returns the Log Level the Logger is configured with.
  // @return A enum value as defined in LogLevel.
  LogLevel getDefaultLogLevel() {
    return defaultLevel;
  }

  static void setLogLevel(LogLevel logLevel) {
    defaultLevel = logLevel;
  }

  static Future<void> logDebug(
      String sourceClass, String sourceMethod, String message) async {
    await _loggerWithLevel(LogLevel.debug, sourceClass, sourceMethod, message);
  }

  static Future<void> logError(
      String sourceClass, String sourceMethod, String message) async {
    await _loggerWithLevel(LogLevel.error, sourceClass, sourceMethod, message);
  }

  static Future<void> logInfo(
      String sourceClass, String sourceMethod, String message) async {
    await _loggerWithLevel(
        LogLevel.important, sourceClass, sourceMethod, message);
  }

  static Future<String> getLogs() async {
    if(kIsWeb){
      return webLogString;
    }
    try {
      final fileUrl = await getLogFileURL();
      final file = File(fileUrl);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("⭕️⭕️⭕️Error while reading log file: $e");
    }
    return "";
  }

  static Future<String> getBackupLogs() async {
    if(kIsWeb){
      return webLogString;
    }
    try {
      final fileUrl = await getBackupLogFileURL();
      final file = File(fileUrl);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("⭕️⭕️⭕️Error while reading backup log file: $e");
    }
    return "";
  }

  static Future<void> deleteLogs() async {
    if(kIsWeb){
      return ;
    }
    try {
      final fileUrl = await getLogFileURL();
      final file = File(fileUrl);
      _loggerWithLevel(LogLevel.important, "Logger", "deleteLogs",
          "Removing File At Path: $fileUrl");
      await file.delete();
    } catch (e) {
      print("⭕️⭕️⭕️Error while deleting log file: $e");
    }
  }

  static Future<String> getLogFileURL() async {
    if(kIsWeb){
      return webLogString;
    }
    var path = await _directoryLocation();
    return '$path/$logFileName';
  }

  static Future<String> getBackupLogFileURL() async {
    if(kIsWeb){
      return webLogString;
    }
    var path = await _directoryLocation();
    return '$path/$backupLogFileName';
  }

  static void setAdditionalInfo() {
    //TODO:
  }

  static void sendLogsToServer() {
    //TODO:
  }
}
