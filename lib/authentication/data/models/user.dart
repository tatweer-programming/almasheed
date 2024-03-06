import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/core/utils/images_manager.dart';

import 'customer.dart';
import 'merchant.dart';

abstract class AppUser {
  String id;
  final String phone;
  String? image;

  Map<String, dynamic> toJson();

  AppUser({required this.id, required this.phone, this.image = ImagesManager.defaultProfile});

  static AppUser fromJson(Map<String, dynamic> json, String type) {
    if (type == 'customer') {
      return Customer.fromJson(json);
    } else if (type == 'merchant') {
      return Merchant.fromJson(json);
    }else if (type == 'worker') {
      return Worker.fromJson(json);
    }
    throw ArgumentError('Invalid user type');
  }

  String getType();
  String getName();
}
