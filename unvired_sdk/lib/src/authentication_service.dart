import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/helper/sso_login_screen.dart';
import 'package:unvired_sdk/src/helper/upgrade_screen.dart';
import 'package:unvired_sdk/src/helper/sync_result.dart';
import 'package:unvired_sdk/src/helper/update_manager.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

import 'database/framework_database.dart';
import 'helper/status.dart';
import 'helper/demo_data_helper.dart';
import 'application_meta/application_metadata_parser.dart';
import 'database/application_manager.dart';
import 'helper/framework_helper.dart';
import 'helper/framework_settings_manager.dart';
import 'helper/http_connection.dart';
import 'helper/path_manager.dart';
import 'helper/url_service.dart';
import 'helper/service_constants.dart';
import 'helper/unvired_account_manager.dart';
import 'helper/user_settings_manager.dart';
import 'sync_engine.dart';
import 'unvired_account.dart';

import 'application_meta/field_constants.dart';
import 'database/database_manager.dart';

enum LoginListenerType {
  auth_activation_required,
  app_requires_login,
  login_success,
  app_requires_current_account,
  login_demo
}

enum AuthenticateAndActivateResultType {
  auth_activation_success,
  auth_activation_error
}

enum AuthenticateLocalResultType { login_success, login_error }

enum LoginType { unvired, ads, sap, email, custom, saml, passwordless }

class UnviredResult {
  var data;
  late String message;
  late String error;
  late String errorDetails;
}

class LoginResult extends UnviredResult {
  late LoginListenerType type;
}

class AuthenticateActivateResult extends UnviredResult {
  late AuthenticateAndActivateResultType type;
}

class AuthenticateLocalResult extends UnviredResult {
  late AuthenticateLocalResultType type;
}

abstract class AuthProtocol {
  Future<UnviredAccount> showLoginScreen(List<UnviredAccount> accounts);

  Future<SSOResult> showWebView(SSOLoginScreen ssoLoginScreen);
}

class AuthenticationService {
  String _appName = "";
  String _metadataPath = "";
  String _metadataJSON = "";
  AuthProtocol? _protocol;
  UnviredAccount? _selectedAccount;
  int _messageInterval = 0;
  bool _containsLocalKeyword = false;
  BuildContext? _context;
  bool _isLoggedIn = false;
  List<String> _channelIds = [];

  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();

  AuthenticationService._internal();

  factory AuthenticationService() {
    return _authenticationService;
  }

  /// Set LoggedIn status.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setLoggedIn(boolValue);
  /// ```
  void setLoggedIn(bool loggedIn) {
    this._isLoggedIn = loggedIn;
  }

  /// Get loggedIn status.
  bool isLoggedIn() {
    return _isLoggedIn;
  }

  /// Get currently selected UnviredAccount object.
  Future<UnviredAccount?> getSelectedAccount() async {
    if (selectedAccount != null) {
      return selectedAccount;
    }
    if (_selectedAccount == null) {
      List<UnviredAccount> accounts =
          await UnviredAccountManager().getAllLoggedInAccounts();
      _selectedAccount = accounts
          .where((element) => element.getIsLastLoggedIn() == true)
          .first;
    }
    return _selectedAccount;
  }

  /// Set Selected UnviredAccount object.
  void setSelectedAccount(UnviredAccount? selectedAccount) {
    this._selectedAccount = selectedAccount;
  }

  /// Get application name.
  String getAppName() {
    return _appName;
  }

  /// Set application name.
  void setAppName(String appName) {
    this._appName = appName;
  }

  /// Returns the polling interval (in seconds) for downloading queued messages PA call.
  int getMessageInterval() {
    return this._messageInterval;
  }

  /// Set metadata.json file path.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setMetadataPath(your_json_file_path);
  /// ```
  void setMetadataPath(String metadataPath) {
    this._metadataPath = metadataPath;
  }

  /// Specify the context to display upgrade screen if upgrade is available.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setContext(context);
  /// ```
  void setContext(BuildContext? context) {
    this._context = context;
  }

  /// This property returns the context set.
  BuildContext? getContext() {
    return this._context;
  }

  /// Specify the metadata as a JSON string. This will override metadata.xml set at platform level.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setMetadataJSON(your_json_string);
  /// ```
  void setMetadataJSON(String metadataJSON) {
    this._metadataJSON = metadataJSON;
  }

  /// Set the class which implements the AuthProtocol
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setAuthProtocol(this);
  /// ```
  void setAuthProtocol(AuthProtocol protocol) {
    this._protocol = protocol;
  }

  /// Set the polling interval (in seconds) for making a Get Message Call.
  /// By default Get Message is not called periodically.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setMessageInterval(600); // 10 minutes polling interval.
  /// ```
  void setMessageInterval(int mesageInterval) {
    this._messageInterval = mesageInterval;
  }

  /// Before calling this method you need to set all the required parameters for the AuthenticationService.
  /// This function should be called in the initial app launch page and application needs to implement the AuthProtocol abstract class function. The 'login' function will call the AuthProtocol abstract class function (showLoginScreen) if the application is not logged in or if the application has multiple logged in accounts.
  /// The 'showLoginScreen' function will have the array of UnviredAccount object as a parameter. Application have to handle the Screens accordingly.
  /// Upon succesfull login, it initializes the databases and makes sure that you can invoke your application specific logic.
  ///
  /// **@return** A boolean value indicating login status.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService authService = AuthenticationService()..setAuthProtocol(this)..setMetadataJSON(your_json_string);
  ///   try {
  ///     bool loginResult = await authService.login();
  ///   } catch (error) {
  ///   }
  /// ```
  Future<bool> login() async {
    return _handleLogin();
  }

  /// Logs the user out of the current account.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService().logout();
  /// ```
  logout() async {
    await _handleLogout();
  }

  /// Returns the list of channel ids which are used for Android push notification.
  List<String> getAndroidPushChannelIds() {
    return this._channelIds;
  }

  /// Set the list of channel ids which needs to be registered for Android push notification.
  ///
  /// **Usage:**
  /// ```dart
  ///   AuthenticationService()..setAndroidPushChannelIds(['System', 'User']);
  /// ```
  void setAndroidPushChannelIds(List<String> channelIds) {
    this._channelIds = channelIds;
  }

  Future<bool> _handleLogin() async {
    if (!kIsWeb) {
      String applicationDirPath = await PathManager.getUploadLogFolderPath();
      Logger.initialize(applicationDirPath);
    }
    Logger.logInfo(
        "AuthenticationService", "login", "Using Framework Version: 1.0");

    if (_protocol == null) {
      throw ("Login process cannot continue because one of the parameters to the Login API, loginDelegate (Object which implements LoginActivityListener) is null. Please make sure that the AuthProtocol is set before invoking the Login API.");
    }

    Logger.logInfo("AuthenticationService", "login", "Started Logging in...");

    if (_metadataJSON.length == 0) {
      String metadata = _loadMetadata(_metadataPath);
      if (metadata.isEmpty) {
        Logger.logError(
            "AuthenticationService", "login", "Metadata is not set.");
        throw ("Could not load metadata.json from Project assets. Make sure the file metadata.json file is present in the project and added into the assets section in pubspec.yaml.");
      } else {
        _metadataJSON = metadata;
      }
    }

    ApplicationMetaDataParser applicationMetaDataParser =
        ApplicationMetaDataParser()..init(_metadataJSON);
    if (applicationMetaDataParser.getApplicationMeta().appName.isEmpty) {
      Logger.logError("AuthenticationService", "login", "Invalid metadata");
      throw ("Invalid metadata. Please provide the valid metadata.json.");
    }

    _appName = applicationMetaDataParser.getApplicationMeta().appName;
    Logger.logInfo("AuthenticationService", "login",
        "APPLICATION NAME: $_appName DEVICE TYPE:${FrameworkHelper.getDeviceType()}");

    List<UnviredAccount> availableAccounts =
        await UnviredAccountManager().getAllLoggedInAccounts();
    return await _callShowLoginAndValidateInput(availableAccounts);
  }

  _handleLogout() async {
    if (_selectedAccount == null) {
      Logger.logError(
          "AuthenticationService", "logout", "Application is not logged in.");
      return;
    }
    // _isLoggedIn = false;
    // _selectedAccount!.setIsLastLoggedIn(false);
    // _selectedAccount!.setIsLastLoggedOut(true);
    // await UnviredAccountManager().updateAccount(_selectedAccount!);
    // await (await DatabaseManager().getFrameworkDB()).close();
    // await (await DatabaseManager().getAppDB()).close();
    // DatabaseManager().clearDatabase();
    await FrameworkHelper.clearData(_selectedAccount!);
  }

  Future<UnviredAccount> _getSelectedFEFromApplication(
      List<UnviredAccount> accounts) async {
    UnviredAccount selectedAccount = await _protocol!.showLoginScreen(accounts);
    selectedAccount.setErrorMessage("");
    if (selectedAccount.getUserName().isEmpty ||
        selectedAccount.getCompany().isEmpty ||
        selectedAccount.getUrl().isEmpty ||
        selectedAccount.getLoginType() == null ||
        ((selectedAccount.getLoginType() == LoginType.ads ||
                selectedAccount.getLoginType() == LoginType.sap) &&
            (selectedAccount.getDomain().isEmpty ||
                selectedAccount.getPort().isEmpty))) {
      selectedAccount.setErrorMessage("Invalid Input.");
      selectedAccount.setPassword("");
      Logger.logError("AuthenticationService", "_callShowLoginAndValidateInput",
          "Invalid Input.");
      return await _getSelectedFEFromApplication([selectedAccount]);
    }
    _selectedAccount!
        .setUrl(URLService.sanitizeLoginURL(_selectedAccount!.getUrl()));

    return selectedAccount;
  }

  Future<bool> _callShowLoginAndValidateInput(
      List<UnviredAccount> accounts) async {
    // Call showLoginScreen protocol
    _selectedAccount = await _protocol!.showLoginScreen(accounts);
    _selectedAccount!.setErrorMessage("");
    if (_selectedAccount!.getUserName().isEmpty ||
        _selectedAccount!.getCompany().isEmpty ||
        _selectedAccount!.getUrl().isEmpty ||
        _selectedAccount!.getLoginType() == null ||
        ((_selectedAccount!.getLoginType() == LoginType.ads ||
                _selectedAccount!.getLoginType() == LoginType.sap) &&
            (_selectedAccount!.getDomain().isEmpty ||
                _selectedAccount!.getPort().isEmpty))) {
      _selectedAccount!.setErrorMessage("Invalid Input.");
      _selectedAccount!.setPassword("");
      Logger.logError("AuthenticationService", "_callShowLoginAndValidateInput",
          "Invalid Input.");
      return await _callShowLoginAndValidateInput([_selectedAccount!]);
    }

    if (_selectedAccount!.getLoginType() == LoginType.saml) {
      if (_selectedAccount!.getToken().isEmpty) {
        SSOResult ssoResult = await _protocol!
            .showWebView(SSOLoginScreen(unviredAccount: _selectedAccount!));
        if (ssoResult.ssoStatus == SSOStatus.SUCCESS) {
          _selectedAccount!.setToken(ssoResult.result);
        } else {
          _selectedAccount!.setErrorMessage(ssoResult.result);
        }
      }
    }

    if (await UnviredAccountManager().isValidAccount(_selectedAccount!)) {
      // // Open Framework and App DB.
      // DatabaseManager();

      // Check If Local Password is Required
      if (_selectedAccount!.getIsLocalPasswordRequired() &&
          _selectedAccount!.getPassword().isEmpty) {
        // Check If Password is entered.
        _selectedAccount!.setErrorMessage("Invalid Input.");
        _selectedAccount!.setPassword("");
        Logger.logError("AuthenticationService",
            "_callShowLoginAndValidateInput", "Invalid Input.");
        return await _callShowLoginAndValidateInput([_selectedAccount!]);
      }

      if (_selectedAccount!.getPassword().isNotEmpty) {
        if (_selectedAccount!.getLoginType() != LoginType.ads &&
            _selectedAccount!.getLoginType() != LoginType.sap) {
          String md5Password =
              FrameworkHelper.getMD5String(_selectedAccount!.getPassword());
          _selectedAccount!.setPassword(md5Password);
        }
      } else {
        String passwordInFw = await UserSettingsManager()
            .getFieldValue(UserSettingsFields.unviredPassword);
        _selectedAccount!.setPassword(passwordInFw);
      }
      // Re Login
      try {
        if (await URLService.isInternetConnected() &&
            await HTTPConnection.isServerReachable()) {
          if (!_selectedAccount!.getIsDemoLogin()) {
            // Get jwt token from rest api
            http.Response jwtResponse =
                await HTTPConnection.getJwtToken(_selectedAccount);
            // Handle jwt Response
            Map<String, dynamic> jwtResponseObject =
                jsonDecode(jwtResponse.body);
            if (jwtResponse.statusCode == Status.httpCreated) {
              await UserSettingsManager().setFieldValue(
                  UserSettingsFields.unviredPassword,
                  _selectedAccount!.getPassword());
            } else {
              String errorMsg = "Login Failed. Error: ";
              if (jwtResponseObject[KeyError] != null &&
                  jwtResponseObject[KeyError].length > 0) {
                errorMsg += jwtResponseObject[KeyError];
              }
              _selectedAccount!.setErrorMessage(errorMsg);
              _selectedAccount!.setPassword("");
              return await _callShowLoginAndValidateInput([_selectedAccount!]);
            }
          }
        } else {
          String passwordInFw = await UserSettingsManager()
              .getFieldValue(UserSettingsFields.unviredPassword);
          if (passwordInFw != _selectedAccount!.getPassword()) {
            _selectedAccount!.setErrorMessage("Incorrect password.");
            _selectedAccount!.setIsLastLoggedIn(false);
            _selectedAccount!.setPassword("");
            Logger.logError("AuthenticationService",
                "_callShowLoginAndValidateInput", "Incorrect password.");
            return await _callShowLoginAndValidateInput([_selectedAccount!]);
          }
        }
      } catch (e) {
        Logger.logError("AuthenticationService",
            "_callShowLoginAndValidateInput", e.toString());
        _selectedAccount!.setErrorMessage(e);
        _selectedAccount!.setIsLastLoggedIn(false);
        _selectedAccount!.setPassword("");
        return await _callShowLoginAndValidateInput([_selectedAccount!]);
      }
    } else {
      Map<String, dynamic> frameworkSettings = {};
      Map<String, dynamic> userSettings = {};
      if (_selectedAccount!.getDemoData().length > 0) {
        _selectedAccount!.setIsDemoLogin(true);
      } else {
        // Check if the account already logged in.
        if (await UnviredAccountManager()
            .isAccountAlreadyPresent(_selectedAccount!)) {
          _selectedAccount!.setErrorMessage("Account already exists.");
          Logger.logError("AuthenticationService",
              "_callShowLoginAndValidateInput", "Account already exists.");
          _selectedAccount!.setPassword("");
          return await _callShowLoginAndValidateInput([_selectedAccount!]);
        }
        _selectedAccount!
            .setUrl(URLService.sanitizeLoginURL(_selectedAccount!.getUrl()));
        // Call authenticate and activate function
        try {
          // If the URL contains "?local", Remove this and Append it to the Last.
          _containsLocalKeyword =
              _selectedAccount!.getUrl().contains(ServiceLocal);
          _selectedAccount!
              .setUrl(_selectedAccount!.getUrl().replaceAll(ServiceLocal, ""));

          if (_selectedAccount!.getLoginType() != LoginType.saml) {
            http.Response? response;
            Map<String, dynamic>? sessionResponseObject;
            if (_selectedAccount!.getLoginType() == LoginType.passwordless) {
              response = await HTTPConnection.authenticateUser(
                  _appName, _selectedAccount!);
              if (_selectedAccount!.getToken().isEmpty) {
                if (response.statusCode == Status.httpNoContent) {
                  // Email for one time token successfully...
                  _selectedAccount!.setErrorMessage(
                      "Tap on the link sent to ${_selectedAccount!.getUserName()}");
                  return await _callShowLoginAndValidateInput(
                      [_selectedAccount!]);
                } else {
                  sessionResponseObject = jsonDecode(response.body);
                  return await notifyLoginFailed(sessionResponseObject);
                }
              } else {
                sessionResponseObject = jsonDecode(response.body);
                if (response.statusCode != Status.httpOk) {
                  return await notifyLoginFailed(sessionResponseObject);
                }
              }
            } else {
              response = await HTTPConnection.authenticateUser(
                  _appName, _selectedAccount!);
              sessionResponseObject = jsonDecode(response.body);
              if (response.statusCode != Status.httpCreated) {
                return await notifyLoginFailed(sessionResponseObject);
              }
            }

            // if (response.statusCode == Status.httpCreated) {
            if (sessionResponseObject![KeySessionId] != null) {
              HTTPConnection.sessionId = sessionResponseObject[KeySessionId];
            }
            if (_selectedAccount!.getLoginType() == LoginType.sap ||
                _selectedAccount!.getLoginType() == LoginType.ads ||
                kIsWeb) {
              _selectedAccount!
                  .setUnviredUser(sessionResponseObject[KeyUnviredId]);
            }
            List<dynamic> userData = sessionResponseObject[KeyUsers];

            List<String> frontendIds = userData
                .where((element) =>
                    element[KeyFrontendType] ==
                        FrameworkHelper.getFrontendType() &&
                    element[KeyApplications] != null &&
                    (element[KeyApplications] as List<dynamic>)
                            .where((e) => e[KeyName] == _appName)
                            .toList()
                            .length >
                        0)
                .map((e) => e[KeyName] as String)
                .toList();
            if (frontendIds.length == 0) {
              _selectedAccount!.setErrorMessage(
                  "Application is not deployed for this user. Please contact your Administrator.");
              _selectedAccount!.setPassword("");
              return await _callShowLoginAndValidateInput([_selectedAccount!]);
            } else if (frontendIds.length > 1) {
              // if(_selectedAccount!.getLoginType()==LoginType.passwordless){
              //   _selectedAccount!.setFrontendId(frontendIds[0]);
              // }else{
              if (_selectedAccount!.getFrontendId().isEmpty) {
                _selectedAccount!.setErrorMessage(
                    "Multiple Frontends are available for this user. Please select one frontend to proceed.");
                _selectedAccount!.setAvailableFrontendIds(frontendIds);
                _selectedAccount!.setPassword("");
                // if(_selectedAccount!.getLoginType()==LoginType.passwordless){
                //
                // }else{
                //   return await _callShowLoginAndValidateInput(
                //       [_selectedAccount!]);
                // }
                _selectedAccount =
                    await _getSelectedFEFromApplication([_selectedAccount!]);
              } else if (!(frontendIds
                  .contains(_selectedAccount!.getFrontendId()))) {
                _selectedAccount!.setErrorMessage("Invalid frontend id.");
                _selectedAccount!.setAvailableFrontendIds(frontendIds);
                _selectedAccount!.setPassword("");
                return await _callShowLoginAndValidateInput(
                    [_selectedAccount!]);
              }
              // }
            } else {
              _selectedAccount!.setFrontendId(frontendIds[0]);
            }

            if (!kIsWeb) {
              // Call activate rest api
              http.Response activationResponse =
                  await HTTPConnection.activateUser(
                      _appName, _selectedAccount!);

              // Handle Activation Response
              Map<String, dynamic> activationResponseObject =
                  jsonDecode(activationResponse.body);
              if (activationResponse.statusCode == Status.httpCreated) {
                frameworkSettings = activationResponseObject;
                _selectedAccount!.setActivationId(
                    frameworkSettings[KeySettings]["activationId"]);
                if (_selectedAccount!.getLoginType() == LoginType.sap ||
                    _selectedAccount!.getLoginType() == LoginType.ads ||
                    _selectedAccount!.getLoginType() ==
                        LoginType.passwordless) {
                  _selectedAccount!.setUnviredUserPwd(
                      activationResponseObject[KeySettings][KeyUnviredMd5Pwd]);
                }
                String unviredId =
                    EnumToString.convertToString(UserSettingsFields.unviredId);
                userSettings[unviredId] = _selectedAccount!.getUserName();
                String unviredPwd = EnumToString.convertToString(
                    UserSettingsFields.unviredPassword);

                String pwdToSave = _selectedAccount!.getPassword();
                if (_selectedAccount!.getLoginType() != LoginType.ads &&
                    _selectedAccount!.getLoginType() != LoginType.sap) {
                  pwdToSave = FrameworkHelper.getMD5String(
                      _selectedAccount!.getPassword());
                }
                userSettings[unviredPwd] = pwdToSave;
                // _selectedAccount!.setUnviredUserPwd(pwdToSave);
              } else {
                String errorMsg = "Login Failed. Error: ";
                if (activationResponseObject[KeyError] != null &&
                    activationResponseObject[KeyError].length > 0) {
                  errorMsg += activationResponseObject[KeyError];
                }
                _selectedAccount!.setErrorMessage(errorMsg);
                _selectedAccount!.setIsLastLoggedIn(false);
                _selectedAccount!.setPassword("");
                return await _callShowLoginAndValidateInput(
                    [_selectedAccount!]);
              }
            } else {
              String unviredId =
                  EnumToString.convertToString(UserSettingsFields.unviredId);
              userSettings[unviredId] = _selectedAccount!.getUserName();
              String unviredPwd = EnumToString.convertToString(
                  UserSettingsFields.unviredPassword);
              String pwdToSave = _selectedAccount!.getPassword();
              if (_selectedAccount!.getLoginType() != LoginType.ads &&
                  _selectedAccount!.getLoginType() != LoginType.sap) {
                pwdToSave = FrameworkHelper.getMD5String(
                    _selectedAccount!.getPassword());
              }
              userSettings[unviredPwd] = pwdToSave;
              _selectedAccount!.setUnviredUserPwd(pwdToSave);
            }

            // Get jwt token from rest api
            http.Response jwtResponse =
                await HTTPConnection.getJwtToken(_selectedAccount);
            // Handle jwt Response
            Map<String, dynamic> jwtResponseObject =
                jsonDecode(jwtResponse.body);
            if (jwtResponse.statusCode != Status.httpCreated) {
              String errorMsg = "Login Failed. Error: ";
              if (jwtResponseObject[KeyError] != null &&
                  jwtResponseObject[KeyError].length > 0) {
                errorMsg += jwtResponseObject[KeyError];
              }
              _selectedAccount!.setErrorMessage(errorMsg);
              _selectedAccount!.setIsLastLoggedIn(false);
              _selectedAccount!.setPassword("");
              return await _callShowLoginAndValidateInput([_selectedAccount!]);
            }
            // } else {
            //   return await notifyLoginFailed(sessionResponseObject);
            // }
          } else {
            if (!kIsWeb) {
              // Call activate rest api
              http.Response activationResponse =
                  await HTTPConnection.activateUser(
                      _appName, _selectedAccount!);

              // Handle Activation Response
              Map<String, dynamic> activationResponseObject =
                  jsonDecode(activationResponse.body);
              if (activationResponse.statusCode == Status.httpCreated) {
                frameworkSettings = activationResponseObject;
                _selectedAccount!.setFrontendId(
                    frameworkSettings[KeySettings]["frontendId"]);
                _selectedAccount!.setActivationId(
                    frameworkSettings[KeySettings]["activationId"]);
                String unviredId =
                    EnumToString.convertToString(UserSettingsFields.unviredId);
                userSettings[unviredId] = _selectedAccount!.getUserName();
                String unviredPwd = EnumToString.convertToString(
                    UserSettingsFields.unviredPassword);
                userSettings[unviredPwd] = FrameworkHelper.getMD5String(
                    _selectedAccount!.getPassword());
              } else {
                String errorMsg = "Login Failed. Error: ";
                if (activationResponseObject[KeyError] != null &&
                    activationResponseObject[KeyError].length > 0) {
                  errorMsg += activationResponseObject[KeyError];
                }
                _selectedAccount!.setErrorMessage(errorMsg);
                _selectedAccount!.setIsLastLoggedIn(false);
                _selectedAccount!.setPassword("");
                return await _callShowLoginAndValidateInput(
                    [_selectedAccount!]);
              }
            } else {
              String unviredId =
                  EnumToString.convertToString(UserSettingsFields.unviredId);
              userSettings[unviredId] = _selectedAccount!.getUserName();
              String unviredPwd = EnumToString.convertToString(
                  UserSettingsFields.unviredPassword);
              userSettings[unviredPwd] =
                  FrameworkHelper.getMD5String(_selectedAccount!.getPassword());
            }

            // Get jwt token from rest api
            http.Response jwtResponse =
                await HTTPConnection.getJwtToken(_selectedAccount);
            // Handle jwt Response
            Map<String, dynamic> jwtResponseObject =
                jsonDecode(jwtResponse.body);
            if (jwtResponse.statusCode != Status.httpCreated) {
              String errorMsg = "Login Failed. Error: ";
              if (jwtResponseObject[KeyError] != null &&
                  jwtResponseObject[KeyError].length > 0) {
                errorMsg += jwtResponseObject[KeyError];
              }
              _selectedAccount!.setErrorMessage(errorMsg);
              _selectedAccount!.setIsLastLoggedIn(false);
              _selectedAccount!.setPassword("");
              return await _callShowLoginAndValidateInput([_selectedAccount!]);
            }
          }
        } catch (e) {
          Logger.logError("AuthenticationService",
              "_callShowLoginAndValidateInput", e.toString());
          _selectedAccount!.setErrorMessage(e);
          _selectedAccount!.setIsLastLoggedIn(false);
          _selectedAccount!.setPassword("");
          return await _callShowLoginAndValidateInput([_selectedAccount!]);
        }
      }

      // Create Tables.
      try {
        ApplicationManager applicationManager = ApplicationManager();
        await applicationManager.initialize(_appName, "");
      } catch (e) {
        Logger.logError("AuthenticationService",
            "_callShowLoginAndValidateInput", e.toString());
        _selectedAccount!.setErrorMessage(e);
        _selectedAccount!.setIsLastLoggedIn(false);
        _selectedAccount!.setPassword("");
        return await _callShowLoginAndValidateInput([_selectedAccount!]);
      }

      if (_selectedAccount!.getDemoData().isNotEmpty) {
        await DemoDataHelper.parseAndInsertDemoData(
            _selectedAccount!.getDemoData());
        frameworkSettings =
            FrameworkSettingsManager.getDemoModeFwSettings(_selectedAccount!);
        userSettings =
            UserSettingsManager.getDemoModeUserSettings(_selectedAccount!);
      }

      if (frameworkSettings.isNotEmpty) {
        // Parse and insert framework data into database
        Map<String, dynamic> fwSettings = frameworkSettings[KeySettings];
        Iterable<String> fwSettingsKeys = fwSettings.keys;
        for (String key in fwSettingsKeys) {
          dynamic value = fwSettings[key];
          FrameworkSettingsFields? fieldEnum =
              EnumToString.fromString(FrameworkSettingsFields.values, key);
          if (fieldEnum != null) {
            if (fieldEnum == FrameworkSettingsFields.localPassword &&
                value == "YES") {
              _selectedAccount!.setIsLocalPasswordRequired(true);
            }
            if (fieldEnum == FrameworkSettingsFields.logLevel) {
              SettingsHelper().setLogLevel(value);
            }
            FrameworkSettingsManager().setFieldValue(fieldEnum, value);
          }

          if (key == KeySystems) {
            FrameworkDatabase frameworkDB =
                await DatabaseManager().getFrameworkDB();
            Map<String, dynamic> systemInfo = value;
            List<dynamic> systemInfoArray = systemInfo[KeySystems];
            for (Map<String, dynamic> systemInfoObj in systemInfoArray) {
              int timestamp = DateTime.now().millisecondsSinceEpoch;
              SystemCredential systemCredentials = SystemCredential(
                  lid: FrameworkHelper.getUUID(),
                  timestamp: timestamp,
                  objectStatus: ObjectStatus.global.index,
                  syncStatus: SyncStatus.none.index,
                  name: systemInfoObj[KeySystemsName],
                  portName: systemInfoObj[KeySystemsPortName],
                  portType: systemInfoObj[KeySystemsPortType],
                  portDesc: systemInfoObj[KeySystemsPortDesc],
                  systemDesc: systemInfoObj[KeySystemsDesc],
                  userId: "",
                  password: "");
              await frameworkDB.addSystemCredential(systemCredentials);
            }
          }

          if (key == KeyLocation) {
            Map<String, dynamic> locationInfo = value;
            Iterable<String> locationInfoKeys = locationInfo.keys;
            for (String key2 in locationInfoKeys) {
              dynamic value2 = locationInfo[key2];
              switch (key2) {
                case KeyLocationTracking:
                  FrameworkSettingsManager().setFieldValue(
                      FrameworkSettingsFields.locationTracking, value2);
                  break;
                case KeyLocationInterval:
                  FrameworkSettingsManager().setFieldValue(
                      FrameworkSettingsFields.locationTrackingInterval, value2);
                  break;
                case KeyLocationUploadInterval:
                  FrameworkSettingsManager().setFieldValue(
                      FrameworkSettingsFields.locationUploadInterval, value2);
                  break;
                case KeyLocationDays:
                  FrameworkSettingsManager().setFieldValue(
                      FrameworkSettingsFields.locationTrackingDays, value2);
                  break;
                case KeyLocationStart:
                  FrameworkSettingsManager().setFieldValue(
                      FrameworkSettingsFields.locationTrackingStart, value2);
                  break;
                case KeyLocationEnd:
                  FrameworkSettingsManager().setFieldValue(
                      FrameworkSettingsFields.locationTrackingEnd, value2);
                  break;
              }
            }
          }
        }
      }

      if (userSettings.isNotEmpty) {
        // Parse and insert user data into database
        Iterable<String> userSettingsKeys = userSettings.keys;
        for (String key in userSettingsKeys) {
          dynamic value = userSettings[key];
          UserSettingsFields? fieldEnum =
              EnumToString.fromString(UserSettingsFields.values, key);
          if (fieldEnum != null) {
            await UserSettingsManager().setFieldValue(fieldEnum, value);
          }
        }
      }
      _selectedAccount!.setDemoData("");
    }

    //Check for upgrade
    bool upgradeAvailable = await UpdateManager().isUpdateAvailable();
    if (upgradeAvailable) {
      if (_context == null) {
        throw "There's an upgrade available,you must set buildContext to show upgrade screen.";
      }
      UnviredAccount? unviredAccount =
          await AuthenticationService().getSelectedAccount();
      var upgradeResult = await Navigator.of(_context!)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return UpgradeScreen(
          unviredAccount: unviredAccount!,
        );
      }));

      if (upgradeResult != null) {
        if (upgradeResult['success'] == true) {
          if (upgradeResult['action'].toString() == "reset") {
            return (await login());
          }
        } else {
          showDialogYesNo(
              message: "Failed to upgrade app",
              onPositiveClick: () {
                Navigator.of(_context!).pop();
              });
          return false;
        }
      }
    }

    // Set last active account
    _selectedAccount!.setIsLastLoggedIn(true);
    if (_selectedAccount!.getLoginType() != LoginType.ads &&
        _selectedAccount!.getLoginType() != LoginType.sap) {
      _selectedAccount!.setPassword("");
    }
    _selectedAccount!.setAppName(AuthenticationService().getAppName());
    await UnviredAccountManager().updateAccount(_selectedAccount!);

    // await DemoDataHelper.parseAndInsertDemoData(
    //     _selectedAccount!.getDemoData());
    _isLoggedIn = true;
    await SyncEngine().initialize();

    // Login Success callback.
    return true;
  }

  Future<bool> notifyLoginFailed(
      Map<String, dynamic>? sessionResponseObject) async {
    String errorMsg = "Login Failed. Error: ";
    if (sessionResponseObject![KeyError] != null &&
        sessionResponseObject[KeyError].length > 0) {
      errorMsg += sessionResponseObject[KeyError];
    }
    _selectedAccount!.setErrorMessage(errorMsg);
    _selectedAccount!.setIsLastLoggedIn(false);
    _selectedAccount!.setPassword("");
    return await _callShowLoginAndValidateInput([_selectedAccount!]);
  }

  String _loadMetadata(String filePath) {
    if (filePath.isEmpty) {
      return "";
    }
    String contents = new File(filePath).readAsStringSync();
    return contents;
  }

  Future<bool> loginWithSSO(
      UnviredAccount unviredAccount, BuildContext context) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SSOLoginScreen(
        unviredAccount: unviredAccount,
      );
    }));
    return result;
  }

  showDialogYesNo({String? message, Function? onPositiveClick}) {
    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(""),
        content: Text(message!),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (onPositiveClick != null) {
                onPositiveClick();
              }
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }
}
