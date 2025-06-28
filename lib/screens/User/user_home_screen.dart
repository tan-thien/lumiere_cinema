import 'package:flutter/material.dart';
import 'package:lumiere_cinema/widgets/custom_navigation_bar.dart';
import 'package:lumiere_cinema/screens/user/home_screen.dart';
import 'package:lumiere_cinema/screens/user/cinema_screen.dart';
import 'package:lumiere_cinema/screens/user/cart_screen.dart';
import 'package:lumiere_cinema/screens/user/news_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CinemaScreen(),
    CartScreen(),
    NewsScreen(),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
     // hoặc nền tối của bạn
    body: Stack(
      children: [
        _screens[_currentIndex],
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
            child: CustomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
      ],
    ),
  );
}

}
