import 'dart:io';

import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
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

  Future<Either<FirebaseAuthException, String>> verifyCode(String code, String userType) async {
    return await _service.verifyCode(code, userType);
  }

  Future<Either<FirebaseException, bool>> createUser(AppUser user) async {
    return await _service.createUser(user);
  }
  Future<Either<FirebaseException, Unit>> updateWorker(Worker worker) async {
    return await _service.updateWorker(worker);
  }

  Future<Either<FirebaseException, String>> loginByPhone(
      String phoneNumber, String userType) async {
    return _service.loginByPhone(phoneNumber, userType);
  }

  Future<Either<FirebaseException, Unit>> addAddress(Address address) async {
    return await _service.addAddress(address);
  }

  Future<Either<FirebaseException, Unit>> removeAddress(Address address) async {
    return await _service.removeAddress(address);
  }

  Future<Either<FirebaseException, Unit>> logout() async {
    return await _service.logout();
  }

  Future<Either<FirebaseException, String>> updateProfilePic(File newImage) async {
    return await _service.uploadProfilePic(newImage);
  }

  Future updateImageInFireStore(String newImageUrl) async {
    return await _service.updateImageInFireStore(newImageUrl);
  }

  Future deleteOldPic(String url) async {
    return await _service.deleteOldPic(url);
  }
}
