class Config {
  String? _name;
  String? _group;
  bool? _enabled;

  Config({required String name, required String group, required bool enabled}) {
    this._name = name;
    this._group = group;
    this._enabled = enabled;
  }

  String get name => _name!;

  set name(String name) => _name = name;

  String get group => _group!;

  set group(String group) => _group = group;

  bool get enabled => _enabled!;

  set enabled(bool enabled) => _enabled = enabled;

  Config.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _group = json['group'];
    _enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['group'] = this._group;
    data['enabled'] = this._enabled;
    return data;
  }
}
