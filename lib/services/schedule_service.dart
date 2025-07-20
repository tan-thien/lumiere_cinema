import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule_model.dart';
import '../utils/api_constants.dart';

class ScheduleService {
  /// ✅ Lấy tất cả lịch chiếu
  static Future<List<Schedule>> getAllSchedules() async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/schedule/getall'),
    );

    print('Status: ${res.statusCode}');
    print('Body: ${res.body}');

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((json) => Schedule.fromJson(json)).toList();
    }

    throw Exception('Failed to load schedules');
  }

  /// ✅ Lấy 1 lịch chiếu theo ID
  static Future<Schedule> getScheduleById(String id) async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/schedule/getbyid/$id'),
    );

    if (res.statusCode == 200) {
      return Schedule.fromJson(json.decode(res.body));
    }

    throw Exception('Schedule not found');
  }

  /// ✅ Tạo lịch chiếu (yêu cầu token)
  static Future<void> createSchedule(Schedule schedule, String token) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/schedule/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(schedule.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Failed to create schedule: ${res.body}');
    }
  }

  /// ✅ Cập nhật lịch chiếu (yêu cầu token)
  static Future<void> updateSchedule(String id, Schedule schedule, String token) async {
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/schedule/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(schedule.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update schedule: ${res.body}');
    }
  }

  /// ✅ Xóa lịch chiếu (yêu cầu token)
  static Future<void> deleteSchedule(String id, String token) async {
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/schedule/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete schedule: ${res.body}');
    }
  }

  /// ✅ Lấy lịch chiếu theo ID phim
static Future<List<Schedule>> getSchedulesByMovieId(String movieId) async {
  final res = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/schedule/by-movie/$movieId'),
  );

  if (res.statusCode == 200) {
    final List data = json.decode(res.body);
    return data.map((json) => Schedule.fromJson(json)).toList();
  }

  throw Exception('Failed to load schedules by movie');
}
/// ✅ Lấy lịch chiếu theo ID rạp
static Future<List<Schedule>> getSchedulesByCinemaId(String cinemaId) async {
  final res = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/schedule/by-cinema/$cinemaId'),
  );

  if (res.statusCode == 200) {
    final List data = json.decode(res.body);
    return data.map((json) => Schedule.fromJson(json)).toList();
  }

  throw Exception('Failed to load schedules by cinema');
}

}
