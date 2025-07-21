import 'package:flutter/material.dart';
import 'package:lumiere_cinema/screens/User/order_history_screen.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 24),

                  // Avatar nổi
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF59B2FF),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tên + Email
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _account!.tenTK,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _account!.email ?? 'Chưa có email',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Barcode
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Nhóm cài đặt chính
                  _buildSection([
                    _buildTile(
                      icon: Icons.history,
                      title: 'Lịch sử đặt vé',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TicketHistoryScreen(),
                            ),
                          ),
                    ),
                    _buildTile(
                      icon: Icons.receipt_long,
                      title: 'Đơn hàng đã đặt',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderHistoryScreen(),
                            ),
                          ),
                    ),
                    _buildTile(icon: Icons.settings, title: 'Cài đặt chung'),
                  ]),

                  const SizedBox(height: 20),

                  // Nhóm hỗ trợ
                  _buildSection([
                    _buildTile(
                      icon: Icons.phone,
                      title: 'Gọi Đường Dây Nóng: 1900 9999',
                    ),
                    _buildTile(
                      icon: Icons.email,
                      title: 'Email: hotro@gmail.com',
                    ),
                    _buildTile(
                      icon: Icons.business,
                      title: 'Thông Tin Công Ty',
                    ),
                    _buildTile(
                      icon: Icons.description,
                      title: 'Điều Khoản Sử Dụng',
                    ),
                    _buildTile(
                      icon: Icons.payment,
                      title: 'Chính Sách Thanh Toán',
                    ),
                    _buildTile(icon: Icons.lock, title: 'Chính Sách Bảo Mật'),
                  ]),

                  const SizedBox(height: 24),

                  // Nút logout
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Center(child: Text('Gọi đường dây nóng: 1900 9999')),
                  const SizedBox(height: 100),
                ],
              ),
    );
  }
}

Widget _buildTile({
  required IconData icon,
  required String title,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.grey.shade700),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}

Widget _buildSection(List<Widget> tiles) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: List.generate(
        tiles.length * 2 - 1,
        (i) => i.isEven ? tiles[i ~/ 2] : const Divider(indent: 60, height: 1),
      ),
    ),
  );
}
