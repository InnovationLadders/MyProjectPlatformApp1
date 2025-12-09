import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  String? _cachedDeviceInfo;

  Future<String> getDeviceInfo() async {
    if (_cachedDeviceInfo != null) {
      return _cachedDeviceInfo!;
    }

    final deviceInfo = DeviceInfoPlugin();
    final buffer = StringBuffer();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        buffer.write('Android ${androidInfo.version.release}');
        buffer.write(' (SDK ${androidInfo.version.sdkInt})');
        buffer.write(' ${androidInfo.manufacturer} ${androidInfo.model}');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        buffer.write('iOS ${iosInfo.systemVersion}');
        buffer.write(' ${iosInfo.name} ${iosInfo.model}');
      } else if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        buffer.write('Web ${webInfo.browserName}');
      } else {
        buffer.write('Unknown Platform');
      }
    } catch (e) {
      buffer.write('Unknown Device');
    }

    _cachedDeviceInfo = buffer.toString();
    return _cachedDeviceInfo!;
  }

  void clearCache() {
    _cachedDeviceInfo = null;
  }
}
