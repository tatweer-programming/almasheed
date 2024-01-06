import 'package:equatable/equatable.dart';

import '../../../main/data/models/product.dart';
import 'orderItem.dart';

class OrderModel extends Equatable {
  final double totalPrice;
  final List<OrderItem> orderItems;
  final List <String> merchantIds ;
  const OrderModel( {required this.totalPrice,
      required this.orderItems , required this.merchantIds});

  static OrderModel create(List<OrderItem> orderItems,) {
    double totalPrice = 0;
    List <String> merchantIds = [];
    for (var element in orderItems ) {
      totalPrice += element.product.productNewPrice * element.quantity;
    // merchantIds.contains(element.product.) ? null : ;
    }
    return OrderModel(totalPrice: totalPrice, orderItems: orderItems , merchantIds:merchantIds);
  }

  @override
  List<Object?> get props => [];
}
