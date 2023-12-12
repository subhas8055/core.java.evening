class ThemeConfig {
  String? _name;
  String? _primaryColor;
  String? _primaryColorDark;
  String? _toolbarIcon;

  ThemeConfig(
      {required String name,
        required String primaryColor,
        required String primaryColorDark,
        required String toolbarIcon}) {
    this._name = name;
    this._primaryColor = primaryColor;
    this._primaryColorDark = primaryColorDark;
    this._toolbarIcon = toolbarIcon;
  }

  ThemeConfig.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _primaryColor = json['primaryColor'];
    _primaryColorDark = json['primaryColorDark'];
    _toolbarIcon = json['toolbarIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['primaryColor'] = this._primaryColor;
    data['primaryColorDark'] = this._primaryColorDark;
    data['toolbarIcon'] = this._toolbarIcon;
    return data;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  String get primaryColor => _primaryColor!;

  set primaryColor(String value) {
    _primaryColor = value;
  }

  String get primaryColorDark => _primaryColorDark!;

  set primaryColorDark(String value) {
    _primaryColorDark = value;
  }

  String get toolbarIcon => _toolbarIcon!;

  set toolbarIcon(String value) {
    _toolbarIcon = value;
  }
}
