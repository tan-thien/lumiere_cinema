import 'package:flutter/material.dart';
import '../../../models/genre.dart';
import '../../../services/genre_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GenreCreateScreen extends StatefulWidget {
  const GenreCreateScreen({Key? key}) : super(key: key);

  @override
  State<GenreCreateScreen> createState() => _GenreCreateScreenState();
}

class _GenreCreateScreenState extends State<GenreCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tenTheLoaiController = TextEditingController();

void _createGenre() async {
  if (_formKey.currentState!.validate()) {
    final newGenre = Genre(tenTheLoai: _tenTheLoaiController.text);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token không tồn tại");

      await GenreService.createGenre(newGenre, token);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo thể loại: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Thể Loại')),
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
                onPressed: _createGenre,
                child: Text('Tạo thể loại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
