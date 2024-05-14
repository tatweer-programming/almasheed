import 'package:almasheed/main/data/models/product.dart';

class OrderItem {
  final Product product;
  int quantity;

  OrderItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id': product.productId,
      'quantity': quantity,
    };
  }
}
