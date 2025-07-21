import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/models/order_detail_model.dart';
import '/services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({required this.orderId, Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<List<OrderDetail>> detailsFuture;

  @override
  void initState() {
    super.initState();
    detailsFuture = OrderService.fetchOrderDetails(widget.orderId);
  }

  String formatCurrency(int value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<OrderDetail>>(
        future: detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('❌ Lỗi tải chi tiết đơn hàng'));
          }

          final details = snapshot.data ?? [];

          if (details.isEmpty) {
            return const Center(child: Text('Không có dịch vụ nào trong đơn hàng'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: details.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = details[index];
                    final service = item.service;
                    final total = item.priceAtOrder * item.quantity;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                service.hinhAnh,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image_not_supported, size: 70),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.tenDichVu,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    service.moTa,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.shopping_cart, size: 18, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text('Số lượng: ${item.quantity}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money, size: 18, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text('Đơn giá: ${formatCurrency(item.priceAtOrder)}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.payments, size: 18, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Thành tiền: ${formatCurrency(total)}',
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // QR Code
                Column(
                  children: [
                    const Text(
                      'Mã QR đơn hàng',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    QrImageView(
                      data: widget.orderId,
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
