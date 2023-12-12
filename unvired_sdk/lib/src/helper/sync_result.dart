class Result {
  int statusCode;
  dynamic body;

  Result(this.statusCode, this.body);
}

enum SSOStatus {SUCCESS,FAILED}

class SSOResult {
  dynamic result;
  SSOStatus ssoStatus;
  SSOResult(this.ssoStatus, this.result);
}

class UpgradeResult{
  bool success;
  String error;
  UpgradeResult(this.success, this.error);

}
