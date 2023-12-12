import 'package:flutter/cupertino.dart';
import 'package:unvired_sdk/src/helper/service_constants.dart';

import '../database/shared.dart';


class DeviceInfo {
  final BuildContext _context;
  late ScreenInfoSize screenInfoSize;
  late DeviceInfoType deviceInfoType;
  late PlatformType platformType;
  late DeviceType deviceType;
  DeviceInfo(this._context) {
    platformType = getPlatform();
    screenInfoSize = ScreenSizeInfo(_context).getScreenSize();
    deviceInfoType = DeviceTypeInfo.getDeviceType(screenInfoSize);
    deviceType = ScreenSizeInfo(_context).getDeviceType();

  }
}

class ScreenSizeInfo {
  final BuildContext _context;

  ScreenSizeInfo(this._context);

  ScreenInfoSize getScreenSize() {
    ScreenInfoSize _screenSize;
    double width = MediaQuery
        .of(_context)
        .size
        .width;
    if (width < 360) {
      _screenSize = ScreenInfoSize.smallPhone;
    } else if (width >= 360 && width <= 600) {
      _screenSize = ScreenInfoSize.phone;
    } else if (width > 600 && width <= 800) {
      _screenSize = ScreenInfoSize.tab;
    } else if (width > 800 && width <= 1000) {
      _screenSize = ScreenInfoSize.largeTab;
    } else {
      _screenSize = ScreenInfoSize.desktop;
    }
    return _screenSize;
  }

  DeviceType getDeviceType() {
    DeviceType _deviceType;
    double width = MediaQuery
        .of(_context)
        .size
        .width;
    if (width < 360) {
      _deviceType = DeviceType.phone;
    } else if (width >= 360 && width <= 600) {
      _deviceType = DeviceType.phone;
    } else if (width > 600 && width <= 800) {
      _deviceType = DeviceType.tab;
    } else if (width > 800 && width <= 1000) {
      _deviceType = DeviceType.tab;
    } else {
      _deviceType = DeviceType.desktop;
    }
    return _deviceType;
  }
}



class DeviceTypeInfo {

  static DeviceInfoType getDeviceType(ScreenInfoSize screenSize) {
    late DeviceInfoType _deviceType;
    PlatformType platformType = getPlatform();
    switch (platformType) {
      case PlatformType.ios:
        if (screenSize == ScreenInfoSize.smallPhone ||
            screenSize == ScreenInfoSize.phone) {
          _deviceType = DeviceInfoType.iPhone;
        } else if (screenSize == ScreenInfoSize.tab ||
            screenSize == ScreenInfoSize.largeTab) {
          _deviceType = DeviceInfoType.iPad;
        } else if (screenSize == ScreenInfoSize.desktop) {
          _deviceType = DeviceInfoType.macOs;
        }
        break;
      case PlatformType.android:
        if (screenSize == ScreenInfoSize.smallPhone ||
            screenSize == ScreenInfoSize.phone) {
          _deviceType = DeviceInfoType.androidPhone;
        } else if (screenSize == ScreenInfoSize.tab ||
            screenSize == ScreenInfoSize.largeTab) {
          _deviceType = DeviceInfoType.androidTablet;
        } else if (screenSize == ScreenInfoSize.desktop) {
          _deviceType = DeviceInfoType.androidTablet;
        }
        break;
      case PlatformType.web:
        if (screenSize == ScreenInfoSize.smallPhone ||
            screenSize == ScreenInfoSize.phone) {
          _deviceType = DeviceInfoType.webPhone;
        } else if (screenSize == ScreenInfoSize.tab ||
            screenSize == ScreenInfoSize.largeTab) {
          _deviceType = DeviceInfoType.webTab;
        } else if (screenSize == ScreenInfoSize.desktop) {
          _deviceType = DeviceInfoType.webDesktop;
        }
        break;
      case PlatformType.linux:
        _deviceType = DeviceInfoType.linux;
        break;
      case PlatformType.windows:
        if (screenSize == ScreenInfoSize.smallPhone ||
            screenSize == ScreenInfoSize.phone) {
          _deviceType = DeviceInfoType.windowsTab;
        } else if (screenSize == ScreenInfoSize.tab ||
            screenSize == ScreenInfoSize.largeTab) {
          _deviceType = DeviceInfoType.windowsTab;
        } else if (screenSize == ScreenInfoSize.desktop) {
          _deviceType = DeviceInfoType.windowsDesktop;
        }
        break;
      case PlatformType.fuchsia:
        _deviceType = DeviceInfoType.fuchsia;
        break;
      case PlatformType.macOs:
        _deviceType = DeviceInfoType.macOs;
        break;
    }
    return _deviceType;
  }
}
