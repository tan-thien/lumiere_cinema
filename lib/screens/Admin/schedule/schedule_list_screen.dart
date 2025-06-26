import 'package:flutter/material.dart';
import '../../../models/schedule_model.dart';
import '../../../services/schedule_service.dart';
import 'schedule_create_screen.dart';
import 'schedule_edit_screen.dart';
import 'schedule_detail_screen.dart';
import 'package:intl/intl.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});

  Future<List<Schedule>> fetchSchedules() async {
    try {
      return await ScheduleService.getAllSchedules();
    } catch (e) {
      print("Lỗi tải lịch chiếu: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách lịch chiếu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScheduleCreateScreen(
              onCreated: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ScheduleListScreen()),
              ),
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Schedule>>(
        future: fetchSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có lịch chiếu nào'));
          }

          final schedules = snapshot.data!;
          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (_, index) {
              final s = schedules[index];
              return ListTile(
                title: Text('${s.tenPhim} - ${s.tenRap}'),
                subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(s.gioChieu)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScheduleDetailScreen(schedule: s),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScheduleEditScreen(
                            schedule: s,
                            onUpdated: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ScheduleListScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
