import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lumiere_cinema/models/ticket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class TicketService {
  static Future<void> bookTicket({
    required String scheduleSeatId,
    required int gia,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('${ApiConstants.baseUrl}/ticket/book');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'scheduleSeatId': scheduleSeatId,
        'Gia': gia,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201 || data['status'] == false) {
      throw Exception(data['message'] ?? 'Đặt vé thất bại');
    }
  }

static Future<List<Ticket>> fetchTicketHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final url = Uri.parse('${ApiConstants.baseUrl}/ticket/user');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print(response.body); // debug

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print(response.body);
    
    if (jsonData is List) {
      return jsonData.map((e) => Ticket.fromJson(e)).toList();
    } else {
      print("Expected List, got: $jsonData");
      return [];
    }
  } else {
    throw Exception('Lấy lịch sử vé thất bại');
  }
}

}
