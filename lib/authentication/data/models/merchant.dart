import 'package:almasheed/authentication/data/models/user.dart';

import '../../../core/utils/images_manager.dart';

class Merchant extends AppUser {
  String companyName;
  String city;
  String area;
  String registrationNumber;
  List<String> orders;
  List<String> productsIds;

  Merchant(
      {required this.companyName,
      required this.city,
      required this.area,
      required this.registrationNumber,
      required this.orders,
      required super.id,
      required super.phone,
      super.image,
      required this.productsIds});

  @override
  Map<String, dynamic> toJson() {
    return {
      "image": image ?? ImagesManager.defaultProfile,
      "productsIds": productsIds,
      'id': id,
      'phone': phone,
      'companyName': companyName,
      'city': city,
      'area': area,
      'registrationNumber': registrationNumber,
      'orders': orders,
    };
  }

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
        image: json["image"] ?? ImagesManager.defaultProfile,
        productsIds: (json['productsIds'] as List).cast<String>(),
        companyName: json['companyName'],
        city: json['city'],
        area: json['area'],
        registrationNumber: json['registrationNumber'],
        orders: (json['orders'] as List).cast<String>(),
        id: json['id'],
        phone: json['phone']);
  }

  @override
  String getType() {
    return "merchant";
  }

  @override
  String getName() {
    return companyName;
  }
}
