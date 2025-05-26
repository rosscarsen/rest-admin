import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String?> getDeviceId() async {
    try {
      if (kIsWeb) {
        WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        return "${webInfo.browserName}-${webInfo.userAgent}"; // 组合浏览器名和UserAgent作为设备ID
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        return androidInfo.id; // Android 设备 ID
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor; // iOS 设备 ID
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
        return windowsInfo.deviceId; // Windows 设备 ID
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
        return macInfo.systemGUID; // macOS 设备 ID
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
        return linuxInfo.machineId; // Linux 设备 ID
      }
    } on PlatformException {
      return null;
    }
    return null;
  }
}
