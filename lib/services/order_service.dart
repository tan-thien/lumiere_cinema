import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';
import '../utils/api_constants.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';
import '../services/auth_service.dart';

class OrderService {
  static final String baseUrl = "${ApiConstants.baseUrl}/order";

  // Tạo đơn hàng
  static Future<bool> createOrder(List<Service> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('token');

    if (userId == null || token == null) return false;

    final body = {
      'services':
          cartItems
              .map((item) => {'serviceId': item.id, 'quantity': 1})
              .toList(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("🔴 Order creation failed: ${response.statusCode}");
      print("📄 Response body: ${response.body}");
      return false;
    }
  }

  // (Có thể thêm các phương thức như getOrdersByUser, getOrderDetails,... sau này nếu cần)
   // Lấy danh sách đơn hàng
  static Future<List<Order>> fetchMyOrders() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/my-orders'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách đơn hàng');
    }
  }

  // Lấy chi tiết đơn hàng
  static Future<List<OrderDetail>> fetchOrderDetails(String orderId) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/details/$orderId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => OrderDetail.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi lấy chi tiết đơn hàng');
    }
  }
  
}
