import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  String name;
  int quantity;
  DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    this.quantity = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0) as int,
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }
}
