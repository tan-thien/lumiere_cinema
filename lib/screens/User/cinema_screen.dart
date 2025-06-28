import 'package:flutter/material.dart';

class CinemaScreen extends StatelessWidget {
  const CinemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🏢 Danh sách rạp chiếu'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Hiển thị danh sách rạp ở đây', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
