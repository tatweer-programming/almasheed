import 'dart:io';

import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthRepository {
  static AuthRepository get = AuthRepository();
  final AuthService _service = AuthService();

  Future<Either<FirebaseAuthException, String>> verifyPhoneNumber(String phoneNumber) async {
    return _service.verifyPhoneNumber(phoneNumber);
  }

  Future<Either<FirebaseAuthException, String>> verifyCode(String code, String userType) {
    return _service.verifyCode(code, userType);
  }

  Future<Either<FirebaseException, bool>> createUser(AppUser user) {
    return _service.createUser(user);
  }

  Future<Either<FirebaseException, String>> loginByPhone(
      String phoneNumber, String userType) async {
    return _service.loginByPhone(phoneNumber, userType);
  }

  Future<Either<FirebaseException, Unit>> addAddress(Address address) async {
    return _service.addAddress(address);
  }

  Future<Either<FirebaseException, Unit>> removeAddress(Address address) async {
    return _service.removeAddress(address);
  }

  Future<Either<FirebaseException, Unit>> logout() {
    return _service.logout();
  }

  Future<Either<FirebaseException, String>> updateProfilePic(File newImage) {
    return _service.uploadProfilePic(newImage);
  }

  Future updateImageInFireStore(String newImageUrl) async {
    return _service.updateImageInFireStore(newImageUrl);
  }

  Future deleteOldPic(String url) async {
    return _service.deleteOldPic(url);
  }
}
