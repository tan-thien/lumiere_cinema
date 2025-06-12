import 'package:flutter/material.dart';
import '../../../models/movie_model.dart';
import '../../../services/movie_service.dart';
import 'movie_create_screen.dart';
import 'movie_edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final data = await MovieService.getAllMovies();
    setState(() => movies = data);
  }

  Future<void> deleteMovie(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    await MovieService.deleteMovie(id, token);
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie List')),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieCreateScreen(onCreated: fetchMovies),
              ),
            ),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (_, index) {
          final movie = movies[index];
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: movie.anhPhim,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            ),

            title: Text(movie.tenPhim),
            subtitle: Text(movie.theLoaiTen ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => MovieEditScreen(
                              movie: movie,
                              onUpdated: fetchMovies,
                            ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteMovie(movie.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
