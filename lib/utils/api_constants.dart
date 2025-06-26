// utils/api_constants.dart

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000"; // Flutter Web chạy trên trình duyệt
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";  // Android Emulator
    } else {
      return "http://192.168.1.86:3000"; // iOS Simulator hoặc thiết bị thật
    }
  }

  static String get loginUrl => "$baseUrl/login";
}

