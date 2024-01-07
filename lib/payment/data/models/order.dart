import 'package:equatable/equatable.dart';

import '../../../core/utils/constance_manager.dart';
import '../../../main/data/models/product.dart';
import 'orderItem.dart';

class OrderModel extends Equatable {
  final double totalPrice;
  final List<OrderItem> orderItems;
  final List<String> merchantIds;
  final String id;

  const OrderModel(
      {required this.id,
      required this.totalPrice,
      required this.orderItems,
      required this.merchantIds});

  static OrderModel create(
    List<OrderItem> orderItems,
  ) {
    double totalPrice = 0;
    List<String> merchantIds = [];
    for (var element in orderItems) {
      totalPrice += element.product.productNewPrice * element.quantity;
      // merchantIds.contains(element.product.) ? null : ;
    }
    return OrderModel(
        id: DateTime.now().toString(),
        totalPrice: totalPrice,
        orderItems: orderItems,
        merchantIds: merchantIds);
  }

  Map<String, dynamic> toJson() => {
        "totalPrice": totalPrice,
        "orderIds": orderItems.map((e) => e.product.productId).toList(),
        "merchantIds": orderItems.map((e) => e.product.merchantId).toList(),
        "customerId": ConstantsManager.appUser!.id,
        "date": id,
      };

  @override
  List<Object?> get props => [];
}
