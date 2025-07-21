import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';
import '/services/order_service.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const Color blueColor = Color(0xFF1976D2);
  static const Color orangeColor = Color(0xFFFFA000);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.cartItems;

    const double exchangeRate = 25000;
    final double totalVND = cart.totalPrice.toDouble();
    final String totalUSD = (totalVND / exchangeRate).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận đơn hàng"),
        backgroundColor: blueColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                items.isEmpty
                    ? const Center(
                      child: Text(
                        "🛒 Giỏ hàng trống",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                    : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final item = items[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item.hinhAnh,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.tenDichVu,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "${item.gia} đ",
                            style: TextStyle(color: orangeColor, fontSize: 14),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () {
                              cart.removeFromCart(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Đã xóa ${item.tenDichVu}"),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
          if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tổng cộng:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${NumberFormat.decimalPattern('vi_VN').format(cart.totalPrice)} đ",
                        style: TextStyle(
                          fontSize: 18,
                          color: orangeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.payment),
                    label: const Text("Thanh toán bằng PayPal"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => PaypalCheckoutView(
                                sandboxMode: true,
                                clientId:
                                    "AfwJlRu9yKhQRe-sZG2u1zKKPQ5YQLoJFYT9cO5fk9oeBlUQV40ALhAdebTtpW5juHbxxBCT8zhZENoa",
                                secretKey:
                                    "EP3BjWMcbooXTSCYZk5wOPotdA_kp35NJVLP5CKNe17ab_APS-3lqZFIwK9GhiTN1CVGEWJlo_fiFBlu",
                                transactions: [
                                  {
                                    "amount": {
                                      "total": totalUSD,
                                      "currency": "USD",
                                      "details": {
                                        "subtotal": totalUSD,
                                        "shipping": '0',
                                        "shipping_discount": 0,
                                      },
                                    },
                                    "description":
                                        "Thanh toán đơn hàng dịch vụ",
                                    "item_list": {
                                      "items":
                                          items.map((item) {
                                            final usdPrice = (item.gia /
                                                    exchangeRate)
                                                .toStringAsFixed(2);
                                            return {
                                              "name": item.tenDichVu,
                                              "quantity": 1,
                                              "price": usdPrice,
                                              "currency": "USD",
                                            };
                                          }).toList(),
                                    },
                                  },
                                ],
                                note: "Cảm ơn bạn đã đặt hàng!",
                                onSuccess: (Map params) async {
                                  final success =
                                      await OrderService.createOrder(items);
                                  if (success) {
                                    cart.clearCart();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "✅ Thanh toán thành công qua PayPal",
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("🚫 Đã hủy thanh toán"),
                                    ),
                                  );
                                },
                                onError: (error) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("❌ Lỗi: $error")),
                                  );
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
