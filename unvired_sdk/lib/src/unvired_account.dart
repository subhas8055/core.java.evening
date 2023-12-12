import 'package:enum_to_string/enum_to_string.dart';

import 'authentication_service.dart';
import 'helper/framework_helper.dart';

class UnviredAccount {
  String _userId = "";
  String _username = "";
  String _password = "";
  String _url = "";
  String _company = "";
  LoginType? _loginType;
  String _domain = "";
  String _frontendId = "";
  String _port = "";
  String _autoSendTime = "";
  String _autoSyncTime = "";
  bool _isLocalPasswordRequired = false;
  bool _isLastLoggedIn = false;
  bool _isLastLoggedOut = false;
  String _demoData = "";
  bool _isDemoLogin = false;
  Object _error = "";
  String _dbPath = "";
  String _token = "";
  String _unviredUserName = "";
  String _unviredUserPwd = "";
  List<String> _availableFrontendIds = [];
  String _activationId = "";
  String _appName = "";

  UnviredAccount() {
    _init();
  }

  _init() async {
    _userId = FrameworkHelper.getUUID();
    // _dbPath = await PathManager.getApplicationPath(_userId);
  }

  String getUserId() {
    return this._userId;
  }

  String getApplicationPath() {
    return this._dbPath;
  }

  /// Set Company name as configured in UMP.
  void setCompany(String company) {
    this._company = company;
  }

  /// Get Company name as configured in UMP.
  String getCompany() {
    return this._company;
  }

  /// Set Token name in case of SSO login.
  void setToken(String token) {
    this._token = token;
  }

  /// Get Token name in case of SSO login.
  String getToken() {
    return this._token;
  }


  /// Set Username of the user trying to login.
  void setUserName(String userName) {
    this._username = userName;
  }

  /// Get Username of the user trying to login.
  String getUserName() {
    return this._username;
  }

  /// Set Password of the user trying to login.
  void setPassword(String password) {
    this._password = password;
  }

  /// Get Password of the user trying to login.
  String getPassword() {
    return this._password;
  }

  /// Set UMP URL. For example: http://192.168.98.160:8080/UMP
  void setUrl(String url) {
    this._url = url;
  }

  /// Get UMP URL. For example: http://192.168.98.160:8080/UMP
  String getUrl() {
    return this._url;
  }

  /// Set this value to one of the allowed login types for your app as configured in UMP. Example LoginType.unvired
  void setLoginType(LoginType loginType) {
    this._loginType = loginType;
  }

  /// Get the login types for your app as configured in UMP. Example LoginType.unvired
  LoginType? getLoginType() {
    return this._loginType;
  }

  /// Set Domain name. Required only if the login type is ads or sap.
  void setDomain(String domain) {
    this._domain = domain;
  }

  /// Get Domain name. Required only if the login type is ads or sap.
  String getDomain() {
    return this._domain;
  }

  /// FrontEndUserId: This id uniquely identifies the user across devices of same type. If the Unvired user has multiple front end ids for a device type, you need to set this value.
  /// If the Unvired user has only one front end id, leave this field blank.
  void setFrontendId(String feId) {
    this._frontendId = feId;
  }

  String getFrontendId() {
    return this._frontendId;
  }

  /// Required only if the loginType is 'sap'. This sets the SAP Port Name.
  void setPort(String port) {
    this._port = port;
  }

  String getPort() {
    return this._port;
  }

  /// Set an interval in seconds at which the framework has to make an attempt to send data from outbox.
  /// If the data-sender fails for reason, then the framework does not restart even if there are outbox items.
  /// In those cases, you will have to set this value, so that the framework always makes an attempt to send from outbox.
  /// Example:
  /// authenticationServcie.setAutoSendTime('5'); // Make an attempt to send data every 5 seconds.
  void setAutoSendTime(String autoSendTime) {
    this._autoSendTime = autoSendTime;
  }

  String getAutoSendTime() {
    return this._autoSendTime;
  }

  /// Set the number of seconds at which GetMessage should automatically run. When this value is set, GetMessage would run in a interval as long as there are entries in Sent Items.
  /// You may need to set this value if your app doesn't support Push Notifications.
  /// By default, the framework does not do GetMessage automatically.
  /// Example:
  /// authenticationServcie.setAutoSyncTime('5'); // Make an attempt to receive data (GetMessage) every 5 seconds.
  void setAutoSyncTime(String autoSyncTime) {
    this._autoSyncTime = autoSyncTime;
  }

  String getAutoSyncTime() {
    return this._autoSyncTime;
  }

  /// Local authentication required or not.
  void setIsLocalPasswordRequired(bool localPasswordRequired) {
    this._isLocalPasswordRequired = localPasswordRequired;
  }

  bool getIsLocalPasswordRequired() {
    return this._isLocalPasswordRequired;
  }

  /// Is Last Logged In account
  void setIsLastLoggedIn(bool isLastLogin) {
    this._isLastLoggedIn = isLastLogin;
  }

  /// Is Last Logged out account
  void setIsLastLoggedOut(bool isLastLogOut) {
    this._isLastLoggedOut = isLastLogOut;
  }

  bool getIsLastLoggedIn() {
    return this._isLastLoggedIn;
  }

  bool getIsLastLoggedOut() {
    return this._isLastLoggedOut;
  }

  /// Demo data json string
  void setDemoData(String demoDataJSON) {
    this._demoData = demoDataJSON;
  }

  String getDemoData() {
    return this._demoData;
  }

  void setIsDemoLogin(bool isDemo) {
    this._isDemoLogin = isDemo;
  }

  bool getIsDemoLogin() {
    return this._isDemoLogin;
  }

  /// Set error occured during login process
  void setErrorMessage(Object error) {
    this._error = error;
  }

  Object getErrorMessage() {
    return this._error;
  }

  void setAvailableFrontendIds(List<String> FrontendIds) {
    this._availableFrontendIds = FrontendIds;
  }

  List<String> getAvailableFrontendIds() {
    return this._availableFrontendIds;
  }

  /// Set UnviredUser name as configured in UMP.
  void setUnviredUser(String user) {
    this._unviredUserName = user;
  }

  /// Get UnviredUser name as configured in UMP.
  String getUnviredUser() {
    return this._unviredUserName;
  }

  /// Set UnviredUserPwd name as configured in UMP.
  void setUnviredUserPwd(String unviredUserPwd) {
    this._unviredUserPwd = unviredUserPwd;
  }

  /// Get UnviredUserPwd name as configured in UMP.
  String getUnviredUserPwd() {
    return this._unviredUserPwd;
  }

  /// Set activationId as configured in UMP.
  void setActivationId(String activationId) {
    this._activationId = activationId;
  }

  /// Get activationId as configured in UMP.
  String getActivationId() {
    return this._activationId;
  }

  /// Set appName from metaData.
  void setAppName(String appName) {
    this._appName = appName;
  }

  /// Get appName from metaData.
  String getAppName() {
    return this._appName;
  }

  UnviredAccount.fromJson(Map<String, dynamic> json) {
    _userId = json['_userId'];
    _username = json['_username'];
    _password = json['_password'];
    _url = json['_url'];
    _company = json['_company'];
    _loginType =
        (json['_loginType'] != null && json['_loginType'].toString().length > 0)
            ? EnumToString.fromString(LoginType.values, json['_loginType'])
            : null;
    _domain = json['_domain'];
    _frontendId = json['_frontendId'];
    _port = json['_port'];
    _autoSendTime = json['_autoSendTime'];
    _autoSyncTime = json['_autoSyncTime'];
    _isLocalPasswordRequired = json['_isLocalPasswordRequired'];
    _isLastLoggedIn = json['_isLastLoggedIn'];
    _isLastLoggedOut = json['_isLastLoggedOut'];
    _demoData = json['_demoData'];
    _isDemoLogin = json['_isDemoLogin'];
    _error = json['_error'];
    _dbPath = json['_dbPath'];
    _activationId = json['_activationId'];
    _appName = json['_appName'];
    _unviredUserName = json['_unviredUserName'];
    _unviredUserPwd = json['_unviredUserPwd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_userId'] = this._userId;
    data['_username'] = this._username;
    data['_password'] = this._password;
    data['_url'] = this._url;
    data['_company'] = this._company;
    data['_loginType'] = this._loginType != null
        ? EnumToString.convertToString(this._loginType)
        : "";
    data['_domain'] = this._domain;
    data['_frontendId'] = this._frontendId;
    data['_port'] = this._port;
    data['_autoSendTime'] = this._autoSendTime;
    data['_autoSyncTime'] = this._autoSyncTime;
    data['_isLocalPasswordRequired'] = this._isLocalPasswordRequired;
    data['_isLastLoggedIn'] = this._isLastLoggedIn;
    data['_isLastLoggedOut'] = this._isLastLoggedOut;
    data['_demoData'] = this._demoData;
    data['_isDemoLogin'] = this._isDemoLogin;
    data['_error'] = this._error;
    data['_dbPath'] = this._dbPath;
    data['_activationId'] = this._activationId;
    data['_appName'] = this._appName;
    data['_unviredUserName'] = this._unviredUserName;
    data['_unviredUserPwd'] = this._unviredUserPwd;
    return data;
  }
}
