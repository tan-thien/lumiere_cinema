import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/branch_model.dart';
import '../utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchService {
  static Future<List<Branch>> getAllBranches() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/branch/getall'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) => Branch.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }

  static Future<Branch> getBranchById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/branch/getbyid/$id'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Branch.fromJson(data['data']);
    } else {
      throw Exception('Failed to load branch');
    }
  }

  static Future<void> createBranch(Branch branch) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token không tồn tại');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/branch/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(branch.toJson()),
    );
    if (response.statusCode != 201) {
      debugPrint('Lỗi tạo chi nhánh: ${response.statusCode}');
      debugPrint('Nội dung lỗi: ${response.body}');
      throw Exception('Failed to create branch');
    }
  }

  static Future<void> updateBranch(Branch branch) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token không tồn tại');
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/branch/update/${branch.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 👈 Thêm token vào đây
      },
      body: jsonEncode(branch.toJson()),
    );

    if (response.statusCode != 200) {
      debugPrint('Lỗi cập nhật: ${response.statusCode}');
      debugPrint('Nội dung lỗi: ${response.body}');
      throw Exception('Cập nhật thất bại');
    }
  }

  static Future<void> deleteBranch(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/branch/delete/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete branch');
    }
  }
}
