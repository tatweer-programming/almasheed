import 'dart:async';

import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static String? verificationID;

  static Completer<String> verificationIdCompleter = Completer<String>();

  Future<Either<FirebaseAuthException, String>> verifyPhoneNumber(
      String phoneNumber) async {
    Completer<Either<FirebaseAuthException, String>> completer =
        Completer<Either<FirebaseAuthException, String>>();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("a completed ");
          // يتم إكمال التحقق تلقائيًا في هذا المكان إذا تم استخدام رقم هاتف موثوق به مسبقًا
        },
        verificationFailed: (FirebaseAuthException e) {
          print('فشل التحقق ${e.message}');
          completer.complete(Left(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          print('تم إرسال رمز التحقق');
          verificationID = verificationId;
          verificationIdCompleter.complete(verificationID);
          completer.complete(Right(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('انتهت مهلة رمز التحقق');
        },
      );
    } on FirebaseAuthException catch (e) {
      completer.complete(Left(e));
    }
    return completer.future;
  }

  Future<String> waitForVerificationID() async {
    return verificationIdCompleter.future;
  }

  Future<Either<FirebaseAuthException, String>> verifyCode(
      String code, String userType) async {
    try {
      late String id;
      print(code);
      final String verificationId = await waitForVerificationID();

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _auth.signInWithCredential(credential).then((value) async {
        id = value.user!.uid;
      });

      return Right(id);
    } on FirebaseAuthException catch (e) {
      print('حدث خطأ أثناء التحقق من رمز التحقق: $e');
      return Left(e);
    }
  }

  Future<bool> _isUserExists(
    String id,
    String userType,
  ) async {
    late bool isExists;
    print(")))))))))))))))))))))))))))))))))))))))))))))))))");
    await _fireStore.collection("${userType}s/").doc(id).get().then((value) {
      isExists =  value.data()!["id"] == id ;


      print("****************************" + value.reference.path);
    });
    return isExists;
  }

  Future<Either<FirebaseException, bool>> createUser(AppUser user) async {
    try {
      bool isCustomer = user is Customer;
      String userType = (user is Customer) ? "customer" : "merchant";

      bool isUserExists = await _isUserExists(user.id, userType);
      if (!isUserExists) {
        if (kDebugMode) {
          print(isUserExists);
        }

        isCustomer
            ? await _createCustomer(user)
            : await _createMerchant(user as Merchant);
      }
      return Right(isUserExists);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future _createCustomer(Customer customer) async {
    try {
      await _fireStore
          .doc("customers/${customer.id})")
          .set(customer.toJson())
          .then((value) {
        print("objectKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future _createMerchant(Merchant merchant) async {
    try {
      await _fireStore
          .doc("merchants/${merchant.id})")
          .set(merchant.toJson())
          .then((value) {
        print("objectKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
