import 'package:flutter/material.dart';
import '../../../models/schedule_model.dart';
import '../../../services/schedule_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleCreateScreen extends StatefulWidget {
  final VoidCallback onCreated;
  const ScheduleCreateScreen({super.key, required this.onCreated});

  @override
  State<ScheduleCreateScreen> createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends State<ScheduleCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gioChieuController = TextEditingController();
  final _maPhimController = TextEditingController();
  final _maPhongController = TextEditingController();
  bool _trangThai = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final schedule = Schedule(
      gioChieu: DateTime.parse(_gioChieuController.text),
      trangThai: _trangThai,
      maPhim: _maPhimController.text,
      tenPhim: '',
      maRap: _maPhongController.text,
      tenRap: '',
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    await ScheduleService.createSchedule(schedule, token); // ✅ Đủ 2 tham số
    widget.onCreated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm lịch chiếu')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _gioChieuController,
                decoration: InputDecoration(
                  labelText: 'Giờ chiếu (yyyy-MM-ddTHH:mm:ss)',
                ),
              ),
              TextFormField(
                controller: _maPhimController,
                decoration: InputDecoration(labelText: 'Mã phim'),
              ),
              TextFormField(
                controller: _maPhongController,
                decoration: InputDecoration(labelText: 'Mã phòng'),
              ),
              SwitchListTile(
                title: Text('Trạng thái'),
                value: _trangThai,
                onChanged: (v) => setState(() => _trangThai = v),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Thêm')),
            ],
          ),
        ),
      ),
    );
  }
}
