import 'package:almasheed/authentication/data/models/user.dart';

import '../../../core/utils/images_manager.dart';

class Worker extends AppUser {
  final String name;
  final String city;
  final String location;
  final double longitude;
  final double latitude;
  final String facility;
  final String brief;
  final List<String> works;
  final List<String> ordersIds;
  final String commercialLicenseNumber;

  Worker({
    required this.name,
    required this.city,
    required this.brief,
    required this.latitude,
    required this.longitude,
    required this.ordersIds,
    required this.location,
    required this.facility,
    required this.commercialLicenseNumber,
    required super.id,
    required this.works,
    required super.phone,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'facility': facility,
      'brief': brief,
      'location': location,
      'name': name,
      'works': works,
      'ordersIds': ordersIds,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'commercialLicenseNumber': commercialLicenseNumber,
    };
  }

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
        name: json['name'],
        brief: json['brief'],
        ordersIds: (json['ordersIds'] as List).cast<String>(),
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
