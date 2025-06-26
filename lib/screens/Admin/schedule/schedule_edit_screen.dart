import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/schedule_model.dart';
import '../../../services/schedule_service.dart';

class ScheduleEditScreen extends StatefulWidget {
  final Schedule schedule;
  final VoidCallback onUpdated;

  const ScheduleEditScreen({
    super.key,
    required this.schedule,
    required this.onUpdated,
  });

  @override
  State<ScheduleEditScreen> createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends State<ScheduleEditScreen> {
  late TextEditingController _gioChieuController;
  late TextEditingController _maPhimController;
  late TextEditingController _maPhongController;
  late bool _trangThai;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _gioChieuController =
        TextEditingController(text: s.gioChieu.toIso8601String());
    _maPhimController = TextEditingController(text: s.maPhim);
    _maPhongController = TextEditingController(text: s.maRap);
    _trangThai = s.trangThai;
  }

  Future<void> _submit() async {
    try {
      final gioChieu = DateTime.parse(_gioChieuController.text);
      final updated = Schedule(
        id: widget.schedule.id,
        gioChieu: gioChieu,
        trangThai: _trangThai,
        maPhim: _maPhimController.text,
        tenPhim: widget.schedule.tenPhim,
        maRap: _maPhongController.text,
        tenRap: widget.schedule.tenRap,
      );

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      await ScheduleService.updateSchedule(updated.id!, updated, token);
      widget.onUpdated();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sửa lịch chiếu')),
      body: Padding(
        padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 20),
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
