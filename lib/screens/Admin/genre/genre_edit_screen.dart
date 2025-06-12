import 'package:flutter/material.dart';
import '../../../models/genre.dart';
import '../../../services/genre_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GenreEditScreen extends StatefulWidget {
  final Genre genre;

  const GenreEditScreen({Key? key, required this.genre}) : super(key: key);

  @override
  State<GenreEditScreen> createState() => _GenreEditScreenState();
}

class _GenreEditScreenState extends State<GenreEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tenTheLoaiController;

  @override
  void initState() {
    super.initState();
    _tenTheLoaiController = TextEditingController(text: widget.genre.tenTheLoai);
  }

void _updateGenre() async {
  if (_formKey.currentState!.validate()) {
    final updated = Genre(id: widget.genre.id, tenTheLoai: _tenTheLoaiController.text);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token không tồn tại");

      await GenreService.updateGenre(widget.genre.id!, updated, token);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật thể loại: $e')),
      );
    }
  }
}

  @override
  void dispose() {
    _tenTheLoaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa Thể Loại')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tenTheLoaiController,
                decoration: InputDecoration(labelText: 'Tên thể loại'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên thể loại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateGenre,
                child: Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
