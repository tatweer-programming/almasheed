import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/core/utils/images_manager.dart';

class Customer extends AppUser {
  Map<String, int> cartItems;
  List<String> favorites;
  List<String> orders;
  List<Address> addresses;
  final String name;
  Customer({
    required this.name,
    required this.cartItems,
    required this.favorites,
    required this.orders,
    required this.addresses,
    required super.id,
    required super.phone,
    super.image,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "image": image ?? ImagesManager.defaultProfile,
      "name": name,
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
      image: json["image"] ?? ImagesManager.defaultProfile,
      name: json["name"],
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

  @override
  String getName() {
    return name;
  }
}
