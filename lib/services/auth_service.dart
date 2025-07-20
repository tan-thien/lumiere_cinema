//services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/account_model.dart';
import '../utils/api_constants.dart';
import '../screens/login_screen.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String tenTK, String pass) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'TenTK': tenTK, 'pass': pass}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == true && data['user'] != null) {
        return {
          'status': true,
          'user': Account.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Đăng nhập thất bại',
        };
      }

      // final token = data['token'];
      // final user = Account.fromJson(data['user']);
      // return {'status': true, 'token': token, 'user': user};
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'status': false,
        'message': errorData['message'] ?? 'Đăng nhập thất bại',
      };
    }
  }

  /// Hàm logout: xóa token & role trong SharedPreferences
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    // Điều hướng về LoginScreen, xóa hết route trước đó
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  /// Hàm gọi API POST kèm token trong header, tự xử lý logout khi token hết hạn (401)
  Future<Map<String, dynamic>> postWithToken(
    BuildContext context,
    String url,
    Map<String, dynamic> body,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Token không tồn tại, điều hướng về login luôn
      await logout(context);
      return {'status': false, 'message': 'Bạn chưa đăng nhập'};
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      // Token hết hạn hoặc không hợp lệ -> logout
      await logout(context);
      return {
        'status': false,
        'message': 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
      };
    }

    if (response.statusCode == 200) {
      return {'status': true, 'data': jsonDecode(response.body)};
    } else {
      return {'status': false, 'message': 'Lỗi server: ${response.statusCode}'};
    }
  }
}
