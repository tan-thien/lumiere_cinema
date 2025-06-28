import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lumiere_cinema/widgets/banner_screen.dart';
import 'package:lumiere_cinema/widgets/now_playing_screen.dart';
import 'package:lumiere_cinema/widgets/coming_soon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDangChieu = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const SizedBox(height: 40),
          const BannerSlider(),
          const SizedBox(height: 20),

          // Thanh chọn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isDangChieu = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isDangChieu
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Đang chiếu",
                              style: TextStyle(
                                color: isDangChieu
                                    ? Colors.blueAccent
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isDangChieu = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: !isDangChieu
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Sắp chiếu",
                              style: TextStyle(
                                color: !isDangChieu
                                    ? Colors.blueAccent
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Hiển thị danh sách
          isDangChieu
              ? const NowPlayingScreen()
              : const ComingSoonScreen(),

          const SizedBox(height: 80,),
        ],
      ),
    );
  }
}
