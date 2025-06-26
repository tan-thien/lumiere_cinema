import 'package:flutter/material.dart';
import '../../../models/cinema.dart';
import '../../../models/branch_model.dart';
import '../../../services/cinema_service.dart';
import '../../../services/branch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CinemaEditScreen extends StatefulWidget {
  final Cinema cinema;

  const CinemaEditScreen({super.key, required this.cinema});

  @override
  State<CinemaEditScreen> createState() => _CinemaEditScreenState();
}

class _CinemaEditScreenState extends State<CinemaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tenRapController;
  late TextEditingController _soLuongGheController;
  bool _trangThai = true;
  String? _selectedBranchId;
  List<Branch> _branches = [];

  @override
  void initState() {
    super.initState();
    _tenRapController = TextEditingController(text: widget.cinema.tenRap);
    _soLuongGheController =
        TextEditingController(text: widget.cinema.soLuongGhe.toString());
    _trangThai = widget.cinema.trangThai;
    _selectedBranchId = widget.cinema.maChiNhanh;

    _loadBranches();
  }

  Future<void> _loadBranches() async {
    try {
      final branches = await BranchService.getAllBranches();
      setState(() {
        _branches = branches;
      });
    } catch (e) {
      print("Lỗi tải danh sách chi nhánh: $e");
    }
  }

  Future<void> _updateCinema() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không tìm thấy token đăng nhập')));
        return;
      }

      final updatedCinema = Cinema(
        id: widget.cinema.id,
        tenRap: _tenRapController.text,
        soLuongGhe: int.parse(_soLuongGheController.text),
        trangThai: _trangThai,
        maChiNhanh: _selectedBranchId,
      );

      try {
        await CinemaService().updateCinema(widget.cinema.id!, updatedCinema, token);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cập nhật thành công!'),
        ));
        Navigator.pop(context, true); // Trả về true để refresh list
      } catch (e) {
        print('Lỗi khi cập nhật: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật thất bại: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tenRapController.dispose();
    _soLuongGheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sửa thông tin rạp')),
      body: _branches.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _tenRapController,
                      decoration: InputDecoration(labelText: 'Tên rạp'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nhập tên rạp' : null,
                    ),
                    TextFormField(
                      controller: _soLuongGheController,
                      decoration: InputDecoration(labelText: 'Số lượng ghế'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập số lượng ghế';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Phải là số nguyên';
                        }
                        return null;
                      },
                    ),
                    SwitchListTile(
                      title: Text('Trạng thái hoạt động'),
                      value: _trangThai,
                      onChanged: (val) {
                        setState(() {
                          _trangThai = val;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedBranchId,
                      items: _branches.map((branch) {
                        return DropdownMenuItem<String>(
                          value: branch.id,
                          child: Text(branch.tenChiNhanh),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBranchId = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Chi nhánh'),
                      validator: (value) =>
                          value == null ? 'Chọn chi nhánh' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateCinema,
                      child: Text('Cập nhật'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
