//Settings Config
`class SettingsConfig {
  List<Config> _config;

  SettingsConfig({List<Config> config}) {
    this._config = config;
  }

  List<Config> get config => _config;
  set config(List<Config> config) => _config = config;

  SettingsConfig.fromJson(Map<String, dynamic> json) {
    if (json['Config'] != null) {
      _config = new List<Config>();
      json['Config'].forEach((v) {
        _config.add(new Config.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._config != null) {
      data['Config'] = this._config.map((v) => v.toJson()).toList();
    }
    return data;
  }
}`

//Config
`class Config {
  String _name;
  String _group;
  bool _enabled;

  Config({String name, String group, bool enabled}) {
    this._name = name;
    this._group = group;
    this._enabled = enabled;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get group => _group;
  set group(String group) => _group = group;
  bool get enabled => _enabled;
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
}`




//Sample data
`{
  "Config": [
    {
      "name": "Inbox",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "OutBox",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "Sent",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "Attachments",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "Info Messages",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "Request data",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "Get message",
      "group": "Messages",
      "enabled": true
    },
    {
      "name": "Timeout",
      "group": "Others",
      "enabled": true
    },
    {
      "name": "Notification",
      "group": "Others",
      "enabled": true
    },
    {
      "name": "Logs",
      "group": "Others",
      "enabled": true
    },
    {
      "name": "Clear data",
      "group": "Others",
      "enabled": true
    },
    {
      "name": "About",
      "group": "Info",
      "enabled": true
    },
    {
      "name": "Appication Version",
      "group": "Info",
      "enabled": true
    },
    {
      "name": "SDK version",
      "group": "Info",
      "enabled": true
    }
  ]
}`
