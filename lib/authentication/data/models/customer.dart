import 'package:almasheed/authentication/data/models/user.dart';

class Customer extends AppUser {
  Map<String, int> cartItems;
  List<String> favorites;
  List<String> orders;

  Customer(
      {required this.cartItems,
      required this.favorites,
      required this.orders,
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
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> cart = json['cartItems'];
    Map<String, int> cartItems = cart.map(
      (key, value) => MapEntry(key, value is int ? value : 0),
    );
    return Customer(
      cartItems: cartItems,
      favorites: (json['favorites'] as List).cast<String>(),
      orders: (json['orders'] as List).cast<String>(),
      id: json['id'],
      phone: json['phone'],
    );
  }
}
