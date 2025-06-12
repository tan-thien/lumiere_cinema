import 'package:flutter/material.dart';
import '../../../models/cinema.dart';
import '../../../models/branch_model.dart';
import '../../../services/cinema_service.dart';
import '../../../services/branch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CinemaFormScreen extends StatefulWidget {
  final Cinema? cinema; // null nếu là thêm mới

  const CinemaFormScreen({super.key, this.cinema});

  @override
  State<CinemaFormScreen> createState() => _CinemaFormScreenState();
}

class _CinemaFormScreenState extends State<CinemaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tenRapController;
  late TextEditingController _soLuongGheController;

  String? _selectedBranchId;
  List<Branch> _branches = [];

  @override
  void initState() {
    super.initState();
    _tenRapController = TextEditingController(text: widget.cinema?.tenRap ?? '');
    _soLuongGheController = TextEditingController(text: widget.cinema?.soLuongGhe.toString() ?? '');
    _selectedBranchId = widget.cinema?.maChiNhanh;

    _loadBranches();
  }

  Future<void> _loadBranches() async {
    final branches = await BranchService.getAllBranches();
    setState(() {
      _branches = branches;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final cinema = Cinema(
        id: widget.cinema?.id,
        tenRap: _tenRapController.text,
        soLuongGhe: int.parse(_soLuongGheController.text),
        trangThai: widget.cinema?.trangThai ?? true,
        maChiNhanh: _selectedBranchId,
      );

      if (widget.cinema == null) {
        await CinemaService().createCinema(cinema, token);
      } else {
        await CinemaService().updateCinema(widget.cinema!.id!, cinema, token);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cinema != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Chỉnh sửa rạp' : 'Thêm rạp')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tenRapController,
                decoration: const InputDecoration(labelText: 'Tên rạp'),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên rạp' : null,
              ),
              TextFormField(
                controller: _soLuongGheController,
                decoration: const InputDecoration(labelText: 'Số lượng ghế'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập số ghế' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedBranchId,
                decoration: const InputDecoration(labelText: 'Chi nhánh'),
                items: _branches.map((branch) {
                  return DropdownMenuItem(
                    value: branch.id,
                    child: Text(branch.tenChiNhanh),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBranchId = value;
                  });
                },
                validator: (value) => value == null ? 'Vui lòng chọn chi nhánh' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
