import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../utils/api_constants.dart';

class MovieService {
  static Future<List<Movie>> getAllMovies() async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/movie/getall'),
    );

    print('Status: ${res.statusCode}');
    print('Body: ${res.body}');

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    }
    throw Exception('Failed to load movies');
  }

  static Future<Movie> getMovieById(String id) async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/movie/getbyid/$id'),
    );
    if (res.statusCode == 200) {
      return Movie.fromJson(json.decode(res.body));
    }
    throw Exception('Movie not found');
  }

  /// ✅ Phương thức tạo phim có sử dụng token
  static Future<void> createMovie(Movie movie, String token) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/movie/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(movie.toJson()),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to create movie: ${res.body}');
    }
  }

  /// ✅ Phương thức cập nhật phim có sử dụng token
  static Future<void> updateMovie(String id, Movie movie, String token) async {
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/movie/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(movie.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update movie: ${res.body}');
    }
  }

  /// ✅ Phương thức xoá phim có sử dụng token
  static Future<void> deleteMovie(String id, String token) async {
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/movie/delete/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to delete movie: ${res.body}');
    }
  }
}
