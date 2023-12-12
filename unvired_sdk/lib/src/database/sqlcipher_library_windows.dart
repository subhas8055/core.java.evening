library sqlite3_library_windows;

import 'dart:ffi' show DynamicLibrary;
import 'dart:io' show Platform, File;
import 'package:logger/logger.dart';
import 'package:path/path.dart';

///relative path to
const assets_package_dir = '';

///relative path to SQLCipher library file
const sqlcipher_windows_dll = 'sqlcipher.dll';

///relative path to OpenSSL library 1
const openssl_lib_crypto_dll = 'libcrypto-1_1-x64.dll';

///relative path to OpenSSL library 2
const openssl_lib_ssl_dll = 'libssl-1_1-x64.dll';

///This function open SQLCipher in memory and return the associated DynamicLibrary.
///Return null if app fail to open SQLCipher.
///set useOpenSSLEmbededDlls to false if you prefer let Windows searching DLLs on the system
DynamicLibrary openSQLCipherOnWindows({bool useOpenSSLEmbededDlls = true}) {
  late DynamicLibrary library;

  String exeDirPath = File(Platform.resolvedExecutable).parent.path;
  Logger.logDebug("SqlCipherWindowsLibrary", "openSQLCipherOnWindows",
      'executableDirectoryPath: $exeDirPath');

  String packageAssetsDirPath = normalize(join(exeDirPath, assets_package_dir));
  Logger.logDebug("SqlCipherWindowsLibrary", "openSQLCipherOnWindows",
      'packageAssetsDirectoryPath: $packageAssetsDirPath');

  //OpenSSL libcryptoxxx.dll FullPath  destination
  String libCryptoDllDestFullPath =
      normalize(join(exeDirPath, openssl_lib_crypto_dll));
  //OpenSSL libsslxxx.dll FullPath  destination
  String libSSLDllDestFullPath =
      normalize(join(exeDirPath, openssl_lib_ssl_dll));

  //OpenSSL libcryptoxxx.dll FullPath  source
  String libCyptoDllSourceFullPath =
      normalize(join(packageAssetsDirPath, openssl_lib_crypto_dll));
  //OpenSSL libsslxxx.dll FullPath  source
  String libSSLDllSourceFullPath =
      normalize(join(packageAssetsDirPath, openssl_lib_ssl_dll));

  //Chek if it is needed to copy DLLs in another directory that my_app.exe could use when executing
  if (useOpenSSLEmbededDlls) {
    bool needToCopy = false;
    //Check if one of destination libraries does not exists
    if (File(libCryptoDllDestFullPath).existsSync() == false ||
        File(libSSLDllDestFullPath).existsSync() == false) {
      //Re sync both libraries
      needToCopy = true;
    } else if (File(libCryptoDllDestFullPath).existsSync() == true ||
        File(libSSLDllDestFullPath).existsSync() == true) {
      //Check if sizes are differents
      needToCopy = (File(libCryptoDllDestFullPath).lengthSync() !=
              File(libCyptoDllSourceFullPath).lengthSync()) ||
          (File(libSSLDllDestFullPath).lengthSync() !=
              File(libSSLDllSourceFullPath).lengthSync());
    }
    //Copy DLLs
    if (needToCopy) {
      File(libCyptoDllSourceFullPath).copySync(libCryptoDllDestFullPath);
      Logger.logDebug(
          "SqlCipherWindowsLibrary",
          "openSQLCipherOnWindows",
          _yellow(
              '$openssl_lib_crypto_dll: copied from $libCyptoDllSourceFullPath to $libCryptoDllDestFullPath'));

      File(libSSLDllSourceFullPath).copySync(libSSLDllDestFullPath);
      Logger.logDebug(
          "SqlCipherWindowsLibrary",
          "openSQLCipherOnWindows",
          _yellow(
              '$openssl_lib_ssl_dll: copied from $libSSLDllSourceFullPath to $libSSLDllDestFullPath'));
    }
  }

  //Now load the SQLCipher DLL
  try {
    String sqliteLibraryPath =
        normalize(join(packageAssetsDirPath, sqlcipher_windows_dll));
    Logger.logDebug("SqlCipherWindowsLibrary", "openSQLCipherOnWindows",
        'SQLCipherLibraryPath: $sqliteLibraryPath');

    library = DynamicLibrary.open(sqliteLibraryPath);
    Logger.logDebug("SqlCipherWindowsLibrary", "openSQLCipherOnWindows",
        _yellow("SQLCipher successfully loaded"));
  } catch (e) {
    try {
      Logger.logError(
          "SqlCipherWindowsLibrary", "openSQLCipherOnWindows", e.toString());
      Logger.logDebug(
          "SqlCipherWindowsLibrary",
          "openSQLCipherOnWindows",
          _red("Failed to load SQLCipher from library file, "
              "trying loading from system..."));

      library = DynamicLibrary.open('sqlcipher.dll');
      Logger.logDebug("SqlCipherWindowsLibrary", "openSQLCipherOnWindows",
          _yellow("SQLCipher successfully loaded"));
    } catch (e) {
      Logger.logError(
          "SqlCipherWindowsLibrary", "openSQLCipherOnWindows", e.toString());
      Logger.logError("SqlCipherWindowsLibrary", "openSQLCipherOnWindows",
          _red("Fail to load SQLCipher."));
    }
  }
  return library;
}

String _red(String string) => '\x1B[31m$string\x1B[0m';

String _yellow(String string) => '\x1B[32m$string\x1B[0m';
