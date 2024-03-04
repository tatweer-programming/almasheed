import 'package:almasheed/authentication/data/models/user.dart';

import '../../../core/utils/images_manager.dart';

class Worker extends AppUser {
  String name;
  String city;
  String location;
  String facility;
  List<String> works;
  String commercialLicenseNumber;

  Worker(
      {required this.name,
      required this.city,
      required this.location,
      required this.facility,
      required this.commercialLicenseNumber,
      required super.id,
      required this.works,
      required super.phone,});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'facility': facility,
      'name': name,
      'works': works,
      'city': city,
      'location': location,
      'commercialLicenseNumber': commercialLicenseNumber,
    };
  }

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
        name: json['name'],
        city: json['city'],
        works: (json['works'] as List).cast<String>(),
        facility: json['facility'],
        location: json['location'],
        commercialLicenseNumber: json['commercialLicenseNumber'],
        id: json['id'],
        phone: json['phone']);
  }

  @override
  String getType() {
    return "worker";
  }

  @override
  String getName() {
    return name;
  }
}
