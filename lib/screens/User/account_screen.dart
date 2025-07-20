import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../models/account_model.dart';
import '../../services/account_service.dart';
import '../login_screen.dart';
import 'package:lumiere_cinema/screens/User/ticket_history_screen.dart';



class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Account? _account;
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }

  Future<void> _loadAccountInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      _userId = userId;
    });

    if (userId != null) {
      try {
        final account = await AccountService.getAccountById(userId);
        setState(() {
          _account = account;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tải tài khoản: $e')));
      }
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Tài Khoản'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        automaticallyImplyLeading: false, // 👈 Xóa nút back
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _account == null
              ? const Center(child: Text('Không tìm thấy tài khoản.'))
              : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const SizedBox(height: 20),

                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 89, 178, 255),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tên và Email
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _account!.tenTK,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _account!.email ?? 'Chưa có email',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Barcode trong khung
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: _userId ?? 'Unknown',
                          width: 300,
                          height: 60,
                          drawText: false,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _userId ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Nhóm cài đặt khác
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                         ListTile(
                          leading: Icon(Icons.history, color: Colors.grey),
                          title: Text('Lịch sử đặt vé'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TicketHistoryScreen(),
                              ),
                            );
                          },
                        ),

                        Divider(indent: 60),
                        ListTile(
                          leading: Icon(Icons.settings, color: Colors.grey),
                          title: Text('Cài đặt chung'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nhóm thông tin hỗ trợ
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.blue),
                          title: Text('Gọi Đường Dây Nóng: 1900 9999'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        Divider(indent: 60),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.blue),
                          title: Text('Email: hotro@gmail.com'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        Divider(indent: 60),
                        ListTile(
                          leading: Icon(Icons.business, color: Colors.green),
                          title: Text('Thông Tin Công Ty'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        Divider(indent: 60),
                        ListTile(
                          leading: Icon(
                            Icons.description,
                            color: Colors.orange,
                          ),
                          title: Text('Điều Khoản Sử Dụng'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        Divider(indent: 60),
                        ListTile(
                          leading: Icon(Icons.payment, color: Colors.purple),
                          title: Text('Chính Sách Thanh Toán'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        Divider(indent: 60),
                        ListTile(
                          leading: Icon(Icons.lock, color: Colors.red),
                          title: Text('Chính Sách Bảo Mật'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Đăng xuất
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Đăng xuất'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  const Center(
                    child: Column(
                      children: [
                        Divider(thickness: 1),
                        SizedBox(height: 8),
                        Text('Gọi đường dây nóng: 1900 9999'),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
    );
  }
}
