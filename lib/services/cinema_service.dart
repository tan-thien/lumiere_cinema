import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cinema.dart';
import '../utils/api_constants.dart';

class CinemaService {
  static final  String baseUrl = "${ApiConstants.baseUrl}/cinema";

  Future<List<Cinema>> getAllCinemas() async {
    final response = await http.get(Uri.parse('$baseUrl/getall'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Cinema.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load cinemas");
    }
  }

  Future<Cinema> getCinemaById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/getbyid/$id'));
    if (response.statusCode == 200) {
      return Cinema.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Cinema not found");
    }
  }

  Future<void> createCinema(Cinema cinema, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cinema.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to create cinema");
    }
  }

  Future<void> updateCinema(String id, Cinema cinema, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cinema.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update cinema");
    }
  }

  Future<void> deleteCinema(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete cinema");
    }
  }
}
