import 'package:flutter/material.dart';
import 'package:lumiere_cinema/widgets/custom_navigation_bar.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('🏠 Trang chủ')),
    const Center(child: Text('🎬 Xem phim')),
    const Center(child: Text('🛒 Giỏ hàng')),
    const Center(child: Text('📽️ Máy chiếu phim')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
