import 'package:equatable/equatable.dart';

import '../../../main/data/models/product.dart';

class OrderModel extends Equatable {
  final List<Product> products;
  final double totalPrice;

  const OrderModel({required this.totalPrice, required this.products});

  static OrderModel create(List<Product> products) {
    double totalPrice = 0;

    for (var element in products) {
      totalPrice += element.productNewPrice;
    }
    return OrderModel(totalPrice: totalPrice, products: products);
  }

  @override
  List<Object?> get props => [];
}
