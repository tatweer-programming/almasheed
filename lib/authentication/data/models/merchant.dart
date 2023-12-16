import 'package:almasheed/authentication/data/models/user.dart';
class Merchant extends AppUser {
  String companyName;
  String city;
  String area;
  String registrationNumber;
  List<String> orders;

  Merchant({
    required this.companyName,
    required this.city,
    required this.area,
    required this.registrationNumber,
    required this.orders, required super.id, required super.phone,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'merchant',
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
      companyName: json['companyName'],
      city: json['city'],
      area: json['area'],
      registrationNumber: json['registrationNumber'],
      orders: (json['orders'] as List).cast<String>(),
      id:  json['id'],
  phone:       json['phone']
    );
  }
}