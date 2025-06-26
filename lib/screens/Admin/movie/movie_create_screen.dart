import 'package:flutter/material.dart';
import '../../../models/movie_model.dart';
import '../../../models/genre.dart';
import '../../../services/movie_service.dart';
import '../../../services/genre_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieCreateScreen extends StatefulWidget {
  final VoidCallback onCreated;
  const MovieCreateScreen({super.key, required this.onCreated});

  @override
  _MovieCreateScreenState createState() => _MovieCreateScreenState();
}

class _MovieCreateScreenState extends State<MovieCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenPhim = TextEditingController();
  final _moTa = TextEditingController();
  final _trailer = TextEditingController();
  final _anhPhim = TextEditingController();
  final _thoiLuong = TextEditingController();
  final _ngay = TextEditingController();

  List<Genre> _genres = [];
  Genre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    try {
      final genres = await GenreService.getAllGenres();
      setState(() {
        _genres = genres;
        if (_genres.isNotEmpty) {
          _selectedGenre = _genres[0];
        }
      });
    } catch (e) {
      print('Lỗi khi tải thể loại: $e');
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedGenre != null) {
      final movie = Movie(
        tenPhim: _tenPhim.text,
        moTa: _moTa.text,
        trailerUrl: _trailer.text,
        anhPhim: _anhPhim.text,
        thoiLuong: int.parse(_thoiLuong.text),
        ngay: DateTime.parse(_ngay.text),
        trangThai: true,
        maTheLoai: _selectedGenre!.id ?? '',
      );
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      await MovieService.createMovie(movie, token);
      widget.onCreated();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tạo Phim')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tenPhim,
                decoration: InputDecoration(labelText: 'Tên phim'),
                validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
              ),
              TextFormField(
                controller: _moTa,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              TextFormField(
                controller: _thoiLuong,
                decoration: InputDecoration(labelText: 'Thời lượng (phút)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ngay,
                decoration: InputDecoration(labelText: 'Ngày (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: _anhPhim,
                decoration: InputDecoration(labelText: 'URL ảnh'),
              ),
              TextFormField(
                controller: _trailer,
                decoration: InputDecoration(labelText: 'Trailer URL'),
              ),

              DropdownButtonFormField<Genre>(
                decoration: InputDecoration(labelText: 'Thể loại'),
                items:
                    _genres.map((genre) {
                      return DropdownMenuItem(
                        value: genre,
                        child: Text(genre.tenTheLoai),
                      );
                    }).toList(),
                value: _selectedGenre,
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Vui lòng chọn thể loại' : null,
              ),

              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Tạo')),
            ],
          ),
        ),
      ),
    );
  }
}
