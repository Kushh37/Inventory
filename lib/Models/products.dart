import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productName;
  final double productPrice;
  final double productQty;
  Product({
    required this.productName,
    required this.productPrice,
    required this.productQty,
  });

  Map<String, dynamic> toDocument() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productQty': productQty,
    };
  }

  static Future<Product?> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    return Product(
      productName: doc["productName"] ?? '',
      productPrice: (doc["productPrice"] ?? 0.0).toDouble(),
      productQty: (doc["productQty"] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() =>
      'Product(productName: $productName, productPrice: $productPrice, productQty: $productQty)';

  Product copyWith({
    String? productName,
    double? productPrice,
    double? productQty,
  }) {
    return Product(
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productQty: productQty ?? this.productQty,
    );
  }
}
