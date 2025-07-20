import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lumiere_cinema/models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nội dung chính
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh đầu bài
                Hero(
                  tag: 'news-image-${news.id}', // phải giống y tag ở danh sách
                  child: Image.network(
                    news.anhTinTuc,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.tieuDe,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (news.tenPhim != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          "Phim liên quan: ${news.tenPhim!}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        news.noiDung.replaceAll(r'\n', '\n'),
                        style: const TextStyle(fontSize: 18, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Nút quay lại bo tròn nhỏ và có blur
          Positioned(
            top: 40,
            left: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 20),
                    padding: const EdgeInsets.all(8), // nhỏ gọn
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
