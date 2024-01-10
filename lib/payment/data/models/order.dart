import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/data/models/address.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../main/data/models/product.dart';
import 'orderItem.dart';

class OrderModel extends Equatable {
  final double totalPrice;
  final List<OrderItem> orderItems;
  final List<String> merchantIds;
  final String id;
  Address address;

  OrderModel(
      {required this.id,
      required this.totalPrice,
      required this.orderItems,
      required this.merchantIds,
      required this.address});

  static OrderModel create(
    List<OrderItem> orderItems,
    Address? address,
  ) {
    double totalPrice = 0;
    List<String> merchantIds = [];
    for (var element in orderItems) {
      totalPrice += element.product.productNewPrice * element.quantity;
      merchantIds.contains(element.product.merchantId)
          ? null
          : merchantIds.add(element.product.merchantId);
    }
    Customer customer = ConstantsManager.appUser as Customer;
    return OrderModel(
        id: DateTime.now().toString(),
        totalPrice: totalPrice,
        orderItems: orderItems,
        merchantIds: merchantIds,
        address: address ?? customer.addresses.first);
  }

  Map<String, dynamic> toJson() => {
        "totalPrice": totalPrice,
        "productIds": orderItems.map((e) => e.product.productId).toList(),
        "merchantsIds": merchantIds,
        "customerId": ConstantsManager.appUser!.id,
        "date": id,
        "address": address.toJson()
      };

  @override
  List<Object?> get props => [];
}
