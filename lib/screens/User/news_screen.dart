import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('📰 Tin tức phim ảnh'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Danh sách bài viết hoặc video tin tức', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
