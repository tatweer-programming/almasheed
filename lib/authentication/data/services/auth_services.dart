import 'dart:async';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/core/local/shared_prefrences.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/address.dart';
import '../models/customer.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static String? verificationID;
  static Completer<String> verificationIdCompleter = Completer<String>();
  Completer<Either<FirebaseAuthException, String>> verifyPhoneCompleter =
      Completer<Either<FirebaseAuthException, String>>();

  Future<Either<FirebaseAuthException, String>> verifyPhoneNumber(
      String phoneNumber) async {
    try {
      _resetVerifyPhoneCompleter();
      _resetVerificationIdCompleter();
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _handleVerificationCompleted,
        verificationFailed: _handleVerificationFailed,
        codeSent: handleCodeSentCase,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException catch (e) {
      verifyPhoneCompleter.complete(Left(e));
    }
    return verifyPhoneCompleter.future;
  }

  Future<String> waitForVerificationID() async {
    return verificationIdCompleter.future;
  }

  Future<Either<FirebaseAuthException, String>> verifyCode(
      String code, String userType) async {
    try {
      String? id;
      final String verificationId = await waitForVerificationID();

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _firebaseAuth.signInWithCredential(credential).then((value) async {
        id = value.user!.uid;
        print(id);
        // await FirebaseMessaging.instance.subscribeToTopic("/topic/$id");
      });

      return Right(id!);
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  Future<bool> _searchForUserById(
    String id,
    String userType,
  ) async {
    late bool isExists;
    await _fireStore
        .collection("${userType}s/")
        .doc(id)
        .get()
        .then((value) async {
      isExists = value.data()?["id"] == id;
      if (isExists) {
        AppUser user = AppUser.fromJson(value.data()!, userType);
        await _saveUser(user, userType);
      }
    });
    return isExists;
  }

  Future<Either<FirebaseAuthException, String>> loginByPhone(
      String phoneNumber, String userType) async {
    try {
      bool exists = await _searchForUsersByPhoneNumber(phoneNumber, userType);
      if (exists) {
        return await verifyPhoneNumber(phoneNumber);
      }
      return const Right("NOT_FOUND");
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  //Create a new user if it does not exist in the Fire store
  Future<Either<FirebaseException, bool>> createUser(AppUser user) async {
    try {
      String userType = user.getType();
      bool isUserExists = await _searchForUserById(user.id, userType);
      isUserExists
          ? DoNothingAction()
          : await _addUSerToFireStore(user, userType);
      return Right(isUserExists);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  // add adress to user
  Future<Either<FirebaseException, Unit>> addAddress(
    Address address,
  ) async {
    try {
      Customer customer = ConstantsManager.appUser as Customer;
      customer.addresses.add(address);
      await _fireStore
          .collection("${customer.getType()}s")
          .doc(customer.id)
          .update({
        "addresses": FieldValue.arrayUnion([address.toJson()])
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<Either<FirebaseException, Unit>> removeAddress(Address address) async {
    try {
      Customer customer = ConstantsManager.appUser as Customer;
      customer.addresses.remove(address);
      await _fireStore
          .collection("${customer.getType()}s")
          .doc(customer.id)
          .update({
        "addresses": FieldValue.arrayRemove([address.toJson()])
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future _addUSerToFireStore(AppUser user, String userType) async {
    try {
      await _fireStore
          .doc("${userType}s/${user.id}")
          .set(user.toJson())
          .then((value) async {
        await _saveUser(user, userType);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> _searchForUsersByPhoneNumber(
      String phone, String userType) async {
    var res = await _fireStore
        .collection("${userType}s")
        .where("phone", isEqualTo: phone)
        .get();
    return res.docs.isNotEmpty;
  }

  Future<void> _saveUser(AppUser user, String userType) async {
    await CacheHelper.saveData(key: "userId", value: user.id);
    await CacheHelper.saveData(key: "userType", value: userType);
    ConstantsManager.appUser = user;
  }

  // verify phone required functions
  void _codeAutoRetrievalTimeout(String verificationId) {
    if (kDebugMode) {
      print('انتهت مهلة رمز التحقق');
    }
  }

  void handleCodeSentCase(String verificationId, int? resendToken) {
    verificationID = verificationId;
    verificationIdCompleter.complete(verificationID);
    verifyPhoneCompleter.complete(Right(verificationId));
  }

  void _handleVerificationCompleted(PhoneAuthCredential credential) {
    if (kDebugMode) {
      print("Verification Completed");
    }
  }

  _handleVerificationFailed(FirebaseAuthException e) {
    if (kDebugMode) {
      print('فشل التحقق ${e.message}');
    }
    verifyPhoneCompleter.complete(Left(e));
  }

  // completers

  void _resetVerifyPhoneCompleter() {
    verifyPhoneCompleter = Completer<Either<FirebaseAuthException, String>>();
  }

  void _resetVerificationIdCompleter() {
    verificationID = null;
    verificationIdCompleter = Completer<String>();
  }
}
