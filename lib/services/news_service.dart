import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../utils/api_constants.dart';

class NewsService {
  static final String baseUrl = "${ApiConstants.baseUrl}/news";

  // Lấy tất cả tin tức
  static Future<List<News>> getAllNews() async {
    final response = await http.get(Uri.parse('$baseUrl/getall'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Lấy 1 tin tức theo ID
  static Future<News> getNewsById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/getbyid/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body)['data'];
      return News.fromJson(jsonData);
    } else {
      throw Exception('News not found');
    }
  }

  // Tạo tin tức mới
  static Future<void> createNews(News news, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "TieuDe": news.tieuDe,
        "NoiDung": news.noiDung,
        "AnhTinTuc": news.anhTinTuc,
        "TenPhim": news.tenPhim,
        "TrangThai": news.trangThai,
      }),
    );
    if (response.statusCode != 201) {
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to create news');
    }
  }

  // Cập nhật tin tức
  static Future<void> updateNews(String id, News news, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "TieuDe": news.tieuDe,
        "NoiDung": news.noiDung,
        "AnhTinTuc": news.anhTinTuc,
        "TenPhim": news.tenPhim,
        "TrangThai": news.trangThai,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update news');
    }
  }

  // Xóa tin tức
  static Future<void> deleteNews(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete news');
    }
  }
}
