import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../helper/status.dart';
import '../authentication_service.dart';
import '../database/database_manager.dart';
import '../helper/http_connection.dart';
import '../helper/path_manager.dart';
import '../helper/service_constants.dart';
import '../unvired_account.dart';

class DatabaseHelper {
  static Future<void> exportAppDatabaseAndSendToServer() async {
    String userId = (await AuthenticationService().getSelectedAccount())!.getUserId();

    // 1. Decrypted DB file path
    String fileUrl = await decryptAppDB();
    File file = File(fileUrl);

    // 2. Zip the DB file
    String appFolder = await PathManager.getApplicationPath(userId);
    String zipPath = appFolder + "/" + UploadLogZip;
    var encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addFile(file);
    encoder.close();

    // 3. Send the Zip file as an attachment
    http.StreamedResponse response =
        await HTTPConnection.uploadLogOrData(zipPath, ActionUploadData);
    if (response.statusCode == Status.httpOk) {
      // 4. Delete the Zip file
      try {
        File uploadedZip = File(zipPath);
        uploadedZip.deleteSync();
        file.deleteSync();
      } catch (e) {
        Logger.logError("SettingsHelper", "sendLogsToServer",
            "Error while deleteing $UploadLogZip. Error: $e");
      }
    }
    return;

  }

  static Future<String> decryptAppDB() async {
    UnviredAccount currentAccount =
        (await AuthenticationService().getSelectedAccount())!;
    String decryptAppDBPath =
        await PathManager.getApplicationPath(currentAccount.getUserId()) +
            "/decrypt_app.sqlite";
    new File(decryptAppDBPath).create();
    await DatabaseManager()
        .execute("ATTACH DATABASE '$decryptAppDBPath' as APP KEY 'unvired';");
    await DatabaseManager().execute("SELECT sqlcipher_export('APP');");
    await DatabaseManager().execute("DETACH DATABASE APP;");
    return decryptAppDBPath;
  }

  static Future<String> decryptFrameworkDB() async {
    UnviredAccount currentAccount =
        (await AuthenticationService().getSelectedAccount())!;
    String decryptFwDBPath =
        await PathManager.getApplicationPath(currentAccount.getUserId()) +
            "/decrypt_app.sqlite";
    new File(decryptFwDBPath).create();
    await DatabaseManager()
        .execute("ATTACH DATABASE '$decryptFwDBPath' as APP KEY 'unvired';");
    await DatabaseManager().execute("SELECT sqlcipher_export('APP');");
    await DatabaseManager().execute("DETACH DATABASE APP;");
    return decryptFwDBPath;
  }
}
