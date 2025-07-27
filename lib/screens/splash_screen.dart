//screens/splash_sceen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/admin_home_screen.dart';
import 'user/user_home_screen.dart';
import 'login_screen.dart';
import 'package:lumiere_cinema/screens/User/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  final token = prefs.getString('token');
  final role = prefs.getString('role');
  final userId = prefs.getString('userId');

  print('🌟 userId from prefs: $userId');

  // 👉 Nếu chưa xem intro thì hiển thị IntroScreen
  if (!hasSeenIntro) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const IntroScreen()),
    );
    return;
  }

  // 👉 Nếu có token thì vào home tương ứng
  if (token != null && role != null && userId != null) {
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminHomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserHomeScreen()),
      );
    }
  } else {
    // 👉 Nếu không có token thì vào LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
