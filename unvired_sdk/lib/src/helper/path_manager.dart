import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as paths;
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart' show kIsWeb;

const String AppDBName = "AppDB.sqlite";
const String FrameworkDBName = "FrameworkDB.sqlite";
const String AppDBTempName = "AppDBTemp.sqlite";

const String WebAppDBName = "AppDB";
const String WebFrameworkDBName = "FrameworkDB";

const String AttachmentFolderName = "Attachment";

const String OutboxFolderName = "Outbox";

const String InboxFolderName = "Inbox";

const String UploadLogFolderName = "log";

const String UploadLogFileName = "uploadLog.txt";
const String UploadLogZip = "uploadLog.zip";

class PathManager {
  static Future<String> getApplicationPath(String userId) async {
    // final supportDir = await paths.getApplicationSupportDirectory();
    // final downloadDir = await paths.getDownloadsDirectory();
    // final tempDir = await paths.getTemporaryDirectory();
    //
    // log("SUPPORT_DIR --> "+supportDir.path.toString());
    // log("DOWNLOAD_DIR --> "+downloadDir!.path.toString());
    // log("TEMP_DIR --> "+tempDir.path.toString());

    final dataDir;
    if (Platform.isWindows) {
      dataDir = await paths.getApplicationSupportDirectory();
    } else {
      dataDir = await paths.getApplicationDocumentsDirectory();
    }
    String dbFolder = dataDir.path;
    if (userId.isNotEmpty) {
      dbFolder = p.join(dataDir.path, userId);
    }

    return dbFolder;
  }

  static Future<String> getAppDBPath(String userId) async {
    String dbFolder = await getApplicationPath(userId);
    String appDbPath = p.join(dbFolder, AppDBName);
    return appDbPath;
  }

  static Future<String> getFrameworkDBPath(String userId) async {
    String dbFolder = await getApplicationPath(userId);
    String fwDbPath = p.join(dbFolder, FrameworkDBName);
    return fwDbPath;
  }

  static Future<String> getAttachmentFolderPath(String userId) async {
    String dbFolder = await getApplicationPath(userId);
    String fwDbPath = p.join(dbFolder, AttachmentFolderName);
    return fwDbPath;
  }

  static Future<String> getOutboxFolderPath(String userId) async {
    String dbFolder = await getApplicationPath(userId);
    String fwDbPath = p.join(dbFolder, OutboxFolderName);
    return fwDbPath;
  }

  static Future<String> getInboxFolderPath(String userId) async {
    String dbFolder = await getApplicationPath(userId);
    String fwDbPath = p.join(dbFolder, InboxFolderName);
    return fwDbPath;
  }

  static Future<bool> isDBAvailable(String userId) async {
    if (kIsWeb) {
      return false;
    }
    String dbFolder = await getApplicationPath(userId);
    String fwDbPath = p.join(dbFolder, FrameworkDBName);
    bool isFwDBAvailabele = File(fwDbPath).existsSync();
    String appDbPath = p.join(dbFolder, AppDBName);
    bool isAppDBAvailabele = File(appDbPath).existsSync();
    if (!isFwDBAvailabele || !isAppDBAvailabele) {
      if (File(dbFolder).existsSync()) {
        File(dbFolder).deleteSync();
      }
      return false;
    }
    return true;
  }

  static copyAttachment(String localPath, String appFolderPath) {
    File file = new File(appFolderPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return File(localPath).copySync(appFolderPath);
  }

  static Future<String> getUploadLogFilePath(String userId) async {
    String appFolder = await getUploadLogFolderPath();
    String uploadLogPath = p.join(appFolder, UploadLogFileName);
    return uploadLogPath;
  }

  static Future<String> getUploadLogFolderPath() async {
    final dataDir;

    if (Platform.isWindows) {
      dataDir = await paths.getApplicationSupportDirectory();
    } else {
      dataDir = await paths.getApplicationDocumentsDirectory();
    }
    String logFolderPath = p.join(dataDir.path, UploadLogFolderName);
    final path = Directory(logFolderPath);

    if (!path.existsSync()) {
      path.createSync(recursive: true);
    }
    return logFolderPath;
  }

  static deleteLoggedInUserFolder(String userId) async {
    //
    // if(Platform.isWindows){
    //   File file =File(
    //       "$userId/$AppDBName" +
    //           "w");
    //  file.deleteSync(recursive: true);
    // }
    String path = await getApplicationPath(userId);
    await Directory(path).delete(recursive: true);
  }

  static Future<String> getApplicationDirectory() async {
    final dataDir = await paths.getApplicationDocumentsDirectory();
    return dataDir.path;
  }
}
