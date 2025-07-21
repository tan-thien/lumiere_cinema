import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/order_model.dart';
import '/services/order_service.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    ordersFuture = OrderService.fetchMyOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _loadOrders();
    });
  }

  // Nhóm đơn hàng theo ngày
  Map<String, List<Order>> _groupOrdersByDate(List<Order> orders) {
    final Map<String, List<Order>> grouped = {};
    for (var order in orders) {
      String dateKey = DateFormat('dd/MM/yyyy').format(order.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(order);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.blueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: FutureBuilder<List<Order>>(
          future: ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('❌ Lỗi khi tải dữ liệu'));
            }

            final orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return const Center(child: Text("🛒 Bạn chưa có đơn hàng nào."));
            }

            final groupedOrders = _groupOrdersByDate(orders);

            return ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              children: groupedOrders.entries.map((entry) {
                final date = entry.key;
                final ordersOnDate = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    ...ordersOnDate.map(
                      (order) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.blue.shade100, width: 1),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long,
                              color: Colors.blueAccent),
                          title: Text(
                            'Đơn hàng #${order.id.substring(0, 6)}...',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Tạo lúc: ${DateFormat('HH:mm').format(order.createdAt)}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: Text(
                            '${NumberFormat("#,###", "vi_VN").format(order.totalAmount)}đ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailScreen(orderId: order.id),
                              ),
                            );
                            _refreshOrders();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
