import 'package:lumiere_cinema/models/service_model.dart';

class OrderDetail {
  final String id;
  final String orderId;
  final Service service;
  final int quantity;
  final int priceAtOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.service,
    required this.quantity,
    required this.priceAtOrder,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['_id'],
      orderId: json['orderId'],
      service: Service.fromJson(json['serviceId']),
      quantity: json['quantity'],
      priceAtOrder: json['priceAtOrder'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }
}
