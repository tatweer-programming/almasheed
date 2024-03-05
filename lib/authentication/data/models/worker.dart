import 'package:almasheed/authentication/data/models/user.dart';

import '../../../core/utils/images_manager.dart';

class Worker extends AppUser {
  final String name;
  final String city;
  final String location;
  final double longitude;
  final double latitude;
  final String facility;
  final List<String> works;
  final String commercialLicenseNumber;

  Worker(
      {required this.name,
      required this.city,
      required this.latitude,
      required this.longitude,
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
      'location': location,
      'name': name,
      'works': works,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
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
        latitude: json['latitude'],
        longitude: json['longitude'],
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
