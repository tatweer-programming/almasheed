import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/payment/data/models/order_item.dart';
import 'package:equatable/equatable.dart';
import '../../../authentication/data/models/address.dart';
import '../../../core/utils/constance_manager.dart';

// ignore_for_file: must_be_immutable
class OrderModel extends Equatable {
  final double totalPrice;
  final List<OrderItem> orderItems;
  final List<String> merchantIds;
  final String id;
  Address? address;

  OrderModel(
      {required this.id,
      required this.totalPrice,
      required this.orderItems,
      required this.merchantIds,
      this.address});

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

    /// TODO : error null check
    if (ConstantsManager.appUser is Customer) {
      return OrderModel(
          id: DateTime.now().toString(),
          totalPrice: totalPrice,
          orderItems: orderItems,
          merchantIds: merchantIds,
          address: address);
    }
    return OrderModel(
        id: "id",
        totalPrice: totalPrice,
        orderItems: orderItems,
        merchantIds: merchantIds,
        address: address!);
  }

  Map<String, dynamic> toJson() => {
        "totalPrice": totalPrice,
        "items": orderItems.map((e) => e.toJson()).toList(),
        "merchantIds": merchantIds,
        "customerId": ConstantsManager.appUser!.id,
        "date": id,
        "address": address!.toJson()
      };

  @override
  List<Object?> get props => [address, id, totalPrice, orderItems];
}
