import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account_model.dart'; // nếu bạn để class Account ở đây thì bỏ dòng này
import '../utils/api_constants.dart';

class AccountService {
  // Lấy danh sách tất cả tài khoản
  static Future<List<Account>> getAllAccounts() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/getall');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body)['accounts'];
      return jsonList.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách tài khoản');
    }
  }

  // Lấy thông tin tài khoản theo ID
  static Future<Account> getAccountById(String id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/getbyid/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['account'];
      return Account.fromJson(json);
    } else {
      throw Exception('Không tìm thấy tài khoản');
    }
  }
}
