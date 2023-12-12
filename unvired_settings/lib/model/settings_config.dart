import 'package:unvired_settings/model/config.dart';

class SettingsConfig {
  List<Config>? _config;



  SettingsConfig({required List<Config> config}) {
    this._config = config;
  }



  List<Config> get config => _config!;
  set config(List<Config> config) => _config = config;



  SettingsConfig.fromJson(Map<String, dynamic> json) {
    if (json['Config'] != null) {
      _config =[];
      json['Config'].forEach((v) {
        _config!.add(new Config.fromJson(v));
      });
    }
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._config != null) {
      data['Config'] = this._config!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


