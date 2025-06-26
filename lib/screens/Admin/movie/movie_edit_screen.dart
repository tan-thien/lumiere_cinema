import 'package:flutter/material.dart';
import '../../../models/movie_model.dart';
import '../../../services/movie_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/genre.dart';
import '../../../services/genre_service.dart';

class MovieEditScreen extends StatefulWidget {
  final Movie movie;
  final VoidCallback onUpdated;

  const MovieEditScreen({super.key, required this.movie, required this.onUpdated});

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
  late bool _trangThai;

  List<Genre> _genres = [];
  Genre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _tenPhim = TextEditingController(text: m.tenPhim);
    _moTa = TextEditingController(text: m.moTa);
    _trailer = TextEditingController(text: m.trailerUrl);
    _anhPhim = TextEditingController(text: m.anhPhim);
    _thoiLuong = TextEditingController(text: m.thoiLuong.toString());
    _ngay = TextEditingController(text: m.ngay.toIso8601String().substring(0, 10));
    _trangThai = m.trangThai;
    loadGenres();
  }

  Future<void> loadGenres() async {
    final allGenres = await GenreService.getAllGenres();
    setState(() {
      _genres = allGenres;
      _selectedGenre = allGenres.firstWhere(
        (g) => g.id == widget.movie.maTheLoai,
        orElse: () => allGenres.first,
      );
    });
  }

  Future<void> _submit() async {
    if (_selectedGenre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn thể loại')),
      );
      return;
    }

    final movie = Movie(
      id: widget.movie.id,
      tenPhim: _tenPhim.text,
      moTa: _moTa.text,
      trailerUrl: _trailer.text,
      anhPhim: _anhPhim.text,
      thoiLuong: int.tryParse(_thoiLuong.text) ?? 0,
      ngay: DateTime.tryParse(_ngay.text) ?? DateTime.now(),
      trangThai: _trangThai,
      maTheLoai: _selectedGenre!.id?? '',
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    await MovieService.updateMovie(movie.id!, movie, token);
    widget.onUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Movie')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: _genres.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView(
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
                    decoration: InputDecoration(labelText: 'Thời lượng (phút)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _ngay,
                    decoration: InputDecoration(labelText: 'Ngày (YYYY-MM-DD)'),
                  ),
                  TextFormField(
                    controller: _anhPhim,
                    decoration: InputDecoration(labelText: 'URL ảnh phim'),
                  ),
                  TextFormField(
                    controller: _trailer,
                    decoration: InputDecoration(labelText: 'URL trailer'),
                  ),
                  DropdownButtonFormField<Genre>(
                    decoration: InputDecoration(labelText: 'Thể loại'),
                    items: _genres.map((genre) {
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
                    validator: (value) =>
                        value == null ? 'Vui lòng chọn thể loại' : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trạng thái: ${_trangThai ? 'Đang chiếu' : 'Ngừng chiếu'}'),
                      Switch(
                        value: _trangThai,
                        onChanged: (value) {
                          setState(() {
                            _trangThai = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Cập nhật'),
                  ),
                ],
              ),
      ),
    );
  }
}
