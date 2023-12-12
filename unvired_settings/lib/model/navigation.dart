class Navigation{
  String? _onClearData;

  Navigation({required String onClearData}){
    this._onClearData=onClearData;
  }

  String get onClearData => _onClearData!;

  set onClearData(String value) {
    _onClearData = value;
  }

  Navigation.fromJson(Map<String, dynamic> json) {
    _onClearData = json['onClearData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onClearData'] = this._onClearData;
    return data;
  }
}