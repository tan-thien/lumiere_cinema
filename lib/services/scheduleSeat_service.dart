import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/scheduleSeat_model.dart';
import '../utils/api_constants.dart';

class ScheduleSeatService {
  static Future<List<ScheduleSeat>> getByScheduleId(String scheduleId) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/schedule-seat/$scheduleId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => ScheduleSeat.fromJson(item)).toList();
    } else {
      throw Exception('Lỗi tải danh sách ghế');
    }
  }
}
