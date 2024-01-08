import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/data/models/user.dart';

class Customer extends AppUser {
  Map<String, int> cartItems;
  List<String> favorites;
  List<String> orders;
  List<Address> addresses;
  Customer(
      {required this.cartItems,
      required this.favorites,
      required this.orders,
      required this.addresses,
      required super.id,
      required super.phone});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'cartItems': cartItems,
      'favorites': favorites,
      'orders': orders,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> cart = json['cartItems'];
    Map<String, int> cartItems = cart.map(
      (key, value) => MapEntry(key, value is int ? value : 0),
    );
    return Customer(
      addresses:
          (json['addresses'] as List).map((e) => Address.fromJson(e)).toList(),
      cartItems: cartItems,
      favorites: (json['favorites'] as List).cast<String>(),
      orders: (json['orders'] as List).cast<String>(),
      id: json['id'],
      phone: json['phone'],
    );
  }

  @override
  String getType() {
    return "customer";
  }
}
