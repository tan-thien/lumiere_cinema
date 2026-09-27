// utils/api_constants.dart

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  static const bool isProduction = true; // 🔄 Bật/tắt giữa local và server thật

  static String get baseUrl {
    if (isProduction) {
      return "https://backend-cinema-u7ai.onrender.com";
    } else {
      return "http://0.0.0.0:3000"; // Local
    }
  }

  static String get loginUrl => "$baseUrl/login";
}


