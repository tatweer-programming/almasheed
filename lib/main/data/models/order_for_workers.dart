import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class OrderForWorkers extends Equatable {
  final String work;
  final String orderDetails;
  final String location;
  final String city;
  final String workerName;
  final String customerName;
  final String customerId;
  final double latitude;
  final bool accepted;
  List<String> workersIds;
  final double longitude;
  String? orderId;

  OrderForWorkers({
    required this.work,
    required this.city,
    required this.workerName,
    required this.location,
    required this.workersIds,
    required this.orderDetails,
    required this.accepted,
    required this.customerId,
    required this.customerName,
    required this.latitude,
    required this.longitude,
    this.orderId,
  });

  factory OrderForWorkers.fromJson(Map<String, dynamic> json) =>
      OrderForWorkers(
        work: json['work'],
        orderDetails: json['orderDetails'],
        latitude: json['latitude'],
        customerId: json['customerId'],
        customerName: json['customerName'],
        location: json['location'],
        workersIds: List<String>.from(json['workersIds'])
            .map((workId) => workId)
            .toList(),
        city: json['city'],
        accepted: json['accepted'],
        longitude: json['longitude'],
        orderId: json['orderId'],
        workerName: json['workerName'],
      );

  Map<String, dynamic> toJson() {
    return {
      "work": work,
      "orderDetails": orderDetails,
      "accepted": accepted,
      "latitude": latitude,
      "workersIds": workersIds,
      "longitude": longitude,
      "city": city,
      "customerName": customerName,
      "customerId": customerId,
      "orderId": orderId,
      "location": location,
      "workerName": workerName
    };
  }

  @override
  List<Object?> get props => [
        work,
        orderDetails,
        latitude,
        longitude,
        location,
        city,
        orderId,
      ];
}
