// screens/Admin/branch_list_screen.dart
import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang người dùng')),
      body: const Center(child: Text('Chào mừng bạn đến Lumiere Cinema!')),
    );
  }
}
