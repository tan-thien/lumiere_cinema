class Order {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
