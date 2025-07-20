import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';
import '../utils/api_constants.dart';

class ServiceService {
  // Lấy tất cả dịch vụ
  static Future<List<Service>> getAllServices() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/service/getall'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((item) => Service.fromJson(item))
          .toList();
    } else {
      throw Exception('Lấy danh sách dịch vụ thất bại');
    }
  }

  // Lấy dịch vụ theo ID
  static Future<Service> getServiceById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/service/getbyid/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Service.fromJson(data['data']);
    } else {
      throw Exception('Không tìm thấy dịch vụ');
    }
  }

  // Thêm dịch vụ mới
  static Future<void> createService(Service service) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token không tồn tại');

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/service/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode != 201) {
      debugPrint('Lỗi tạo dịch vụ: ${response.statusCode}');
      debugPrint('Chi tiết: ${response.body}');
      throw Exception('Không thể tạo dịch vụ');
    }
  }

  // Cập nhật dịch vụ
  static Future<void> updateService(Service service) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token không tồn tại');

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/service/update/${service.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode != 200) {
      debugPrint('Lỗi cập nhật dịch vụ: ${response.statusCode}');
      debugPrint('Chi tiết: ${response.body}');
      throw Exception('Không thể cập nhật dịch vụ');
    }
  }

  // Xóa dịch vụ
  static Future<void> deleteService(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token không tồn tại');

    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/service/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      debugPrint('Lỗi xóa dịch vụ: ${response.statusCode}');
      debugPrint('Chi tiết: ${response.body}');
      throw Exception('Xóa dịch vụ thất bại');
    }
  }
}
