import 'package:flutter/material.dart';
import '../../../models/movie_model.dart';
import '../../../services/movie_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieEditScreen extends StatefulWidget {
  final Movie movie;
  final VoidCallback onUpdated;

  MovieEditScreen({required this.movie, required this.onUpdated});

  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {
  late TextEditingController _tenPhim;
  late TextEditingController _moTa;
  late TextEditingController _trailer;
  late TextEditingController _anhPhim;
  late TextEditingController _thoiLuong;
  late TextEditingController _ngay;
  late TextEditingController _maTheLoai;

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _tenPhim = TextEditingController(text: m.tenPhim);
    _moTa = TextEditingController(text: m.moTa);
    _trailer = TextEditingController(text: m.trailerUrl);
    _anhPhim = TextEditingController(text: m.anhPhim);
    _thoiLuong = TextEditingController(text: m.thoiLuong.toString());
    _ngay = TextEditingController(
      text: m.ngay.toIso8601String().substring(0, 10),
    );
    _maTheLoai = TextEditingController(text: m.maTheLoai);
  }

  Future<void> _submit() async {
    final movie = Movie(
      id: widget.movie.id,
      tenPhim: _tenPhim.text,
      moTa: _moTa.text,
      trailerUrl: _trailer.text,
      anhPhim: _anhPhim.text,
      thoiLuong: int.parse(_thoiLuong.text),
      ngay: DateTime.parse(_ngay.text),
      trangThai: true,
      maTheLoai: _maTheLoai.text,
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    await MovieService.createMovie(movie, token);
    widget.onUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Movie')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: [
            TextFormField(
              controller: _tenPhim,
              decoration: InputDecoration(labelText: 'Tên phim'),
            ),
            TextFormField(
              controller: _moTa,
              decoration: InputDecoration(labelText: 'Mô tả'),
            ),
            TextFormField(
              controller: _thoiLuong,
              decoration: InputDecoration(labelText: 'Thời lượng'),
            ),
            TextFormField(
              controller: _ngay,
              decoration: InputDecoration(labelText: 'Ngày'),
            ),
            TextFormField(
              controller: _anhPhim,
              decoration: InputDecoration(labelText: 'Ảnh'),
            ),
            TextFormField(
              controller: _trailer,
              decoration: InputDecoration(labelText: 'Trailer'),
            ),
            TextFormField(
              controller: _maTheLoai,
              decoration: InputDecoration(labelText: 'Mã thể loại'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('Cập nhật')),
          ],
        ),
      ),
    );
  }
}
