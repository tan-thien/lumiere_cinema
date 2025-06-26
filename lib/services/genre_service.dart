import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/genre.dart';
import '../utils/api_constants.dart';

class GenreService {
  static final  String baseUrl = "${ApiConstants.baseUrl}/genre";

  static Future<List<Genre>> getAllGenres() async {
    final response = await http.get(Uri.parse('$baseUrl/getall'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Genre.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  static Future<Genre> getGenreById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/getbyid/$id'));
    if (response.statusCode == 200) {
      return Genre.fromJson(json.decode(response.body));
    } else {
      throw Exception('Genre not found');
    }
  }

  static Future<void> createGenre(Genre genre, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(genre.toJson()),
    );
    if (response.statusCode != 201) {
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    throw Exception('Failed to create genre');
    }
  }

  static Future<void> updateGenre(String id, Genre genre, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(genre.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update genre');
    }
  }

  static Future<void> deleteGenre(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete genre');
    }
  }
}
