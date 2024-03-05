import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class OrderForWorkers extends Equatable {
  final String work;
  final String orderDetails;
  final double latitude;
  final double longitude;
  final String id;

  const OrderForWorkers({
    required this.work,
    required this.orderDetails,
    required this.latitude,
    required this.longitude,
    required this.id,
  });

  factory OrderForWorkers.fromJson(Map<String, dynamic> json) =>
      OrderForWorkers(
        work: json['work'],
        orderDetails: json['orderDetails'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() {
    return {
      "work": work,
      "orderDetails": orderDetails,
      "latitude": latitude,
      "longitude": longitude,
      "id": id,
    };
  }

  @override
  List<Object?> get props => [
        work,
        orderDetails,
        latitude,
        longitude,
        id,
      ];
}
