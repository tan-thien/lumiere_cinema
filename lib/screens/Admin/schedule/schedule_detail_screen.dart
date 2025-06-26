import 'package:flutter/material.dart';
import '../../../models/schedule_model.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final Schedule schedule;
  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết lịch chiếu')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phim: ${schedule.tenPhim}', style: TextStyle(fontSize: 18)),
            Text('Phòng: ${schedule.tenRap}', style: TextStyle(fontSize: 18)),
            Text('Giờ chiếu: ${schedule.gioChieu}', style: TextStyle(fontSize: 18)),
            Text('Trạng thái: ${schedule.trangThai ? "Đang chiếu" : "Ngừng chiếu"}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
