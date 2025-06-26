import 'package:flutter/material.dart';
import '../../../models/genre.dart';
import '../../../services/genre_service.dart';
import 'genre_create_screen.dart';
import 'genre_edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenreListScreen extends StatefulWidget {
  const GenreListScreen({super.key});

  @override
  _GenreListScreenState createState() => _GenreListScreenState();
}

class _GenreListScreenState extends State<GenreListScreen> {
  List<Genre> _genres = [];

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    final genres = await GenreService.getAllGenres();
    setState(() {
      _genres = genres;
    });
  }

void _deleteGenre(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null) return;

  try {
    await GenreService.deleteGenre(id, token);
    _loadGenres();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Xóa thất bại: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý thể loại")),
      body: ListView.builder(
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          final genre = _genres[index];
          return ListTile(
            title: Text(genre.tenTheLoai),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GenreEditScreen(genre: genre),
                      ),
                    );
                    if (result == true) _loadGenres();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteGenre(genre.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GenreCreateScreen(),
            ),
          );
          if (result == true) _loadGenres();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
