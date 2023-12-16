import 'customer.dart';
import 'merchant.dart';

abstract class AppUser {
final  String id;
final  String phone;
const AppUser({required this.id, required this.phone});
  Map<String, dynamic> toJson();

  static AppUser fromJson(Map<String, dynamic> json , String type) {
    if (type == 'customer') {
      return Customer.fromJson(json);
    } else if (type == 'merchant') {
      return Merchant.fromJson(json);
    }
    throw ArgumentError('Invalid user type');
  }
}