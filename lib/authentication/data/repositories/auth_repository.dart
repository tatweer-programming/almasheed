import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository{
final AuthService _service = AuthService();

  Future<bool> verifyPhoneNumber(String phoneNumber) async {
return _service.verifyPhoneNumber(phoneNumber);
  }
Future<bool> verifyCode(String code)async {

    return _service.verifyCode(code);
}
}
