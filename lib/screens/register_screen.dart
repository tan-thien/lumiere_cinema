import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // <- thêm dòng này
import '../utils/api_constants.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenTKController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;
  bool _isPrivacyAccepted = false; // <- thêm biến này

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/registration"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'TenTK': _tenTKController.text.trim(),
        'pass': _passController.text.trim(),
        'email': _emailController.text.trim(),
      }),
    );

    setState(() => _isLoading = false);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
              child: child,
            );
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'] ?? 'Đăng ký thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          SizedBox(
            height: screenHeight * 0.35,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/regis.jpg', fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black45, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container chính
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF7FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Đăng ký tài khoản',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _tenTKController,
                        decoration: _buildInputDecoration(
                          'Tên tài khoản',
                          Icons.person,
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Vui lòng nhập tên tài khoản'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDecoration('Email', Icons.email),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Vui lòng nhập email'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                          'Mật khẩu',
                          Icons.lock,
                        ),
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? 'Mật khẩu ít nhất 6 ký tự'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      // Checkbox điều khoản
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isPrivacyAccepted,
                            onChanged: (value) {
                              setState(() {
                                _isPrivacyAccepted = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                const url =
                                    'https://www.freeprivacypolicy.com/live/91ebc720-3ed8-4cc1-871f-d6a2ea3e697c';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Tôi đồng ý với ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'chính sách bảo mật',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Nút đăng ký
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading || !_isPrivacyAccepted
                                  ? null
                                  : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'Đăng ký',
                                    style: TextStyle(color: Colors.white),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Điều hướng tới đăng nhập
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đã có tài khoản?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  pageBuilder:
                                      (_, __, ___) => const LoginScreen(),
                                  transitionsBuilder: (
                                    _,
                                    animation,
                                    __,
                                    child,
                                  ) {
                                    final slide = Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.ease,
                                      ),
                                    );
                                    return SlideTransition(
                                      position: slide,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }
}
