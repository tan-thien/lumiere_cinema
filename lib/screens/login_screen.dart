//screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:lumiere_cinema/screens/Admin/admin_home_screen.dart';
import 'package:lumiere_cinema/screens/User/user_home_screen.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _tenTKController = TextEditingController();
  final _passController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    final result = await _authService.login(
      _tenTKController.text.trim(),
      _passController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['status']) {
      final user = result['user'];
      final token = result['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', user.role);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xin chào ${user.tenTK} (${user.role})')),
      );

      // 👉 Phân quyền: chuyển hướng theo role
      if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  AdminHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomeScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tenTKController,
              decoration: const InputDecoration(labelText: 'Tên tài khoản'),
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Đăng nhập'),
                  ),
          ],
        ),
      ),
    );
  }
}
