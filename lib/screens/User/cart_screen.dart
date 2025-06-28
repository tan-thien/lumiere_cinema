import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🛒 Giỏ hàng'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Các sản phẩm trong giỏ hàng', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
