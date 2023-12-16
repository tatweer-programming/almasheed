import 'dart:async';

import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? verificationID;

  static Completer<String> verificationIdCompleter = Completer<String>();

  Future<Either<String, String>> verifyPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("a completed ");
          // يتم إكمال التحقق تلقائيًا في هذا المكان إذا تم استخدام رقم هاتف موثوق به مسبقًا
        },
        verificationFailed: (FirebaseAuthException e) {
          print('فشل التحقق ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('تم إرسال رمز التحقق');
          verificationID = verificationId;
          verificationIdCompleter.complete(verificationID);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('انتهت مهلة رمز التحقق');
        },
      );

      return Right(await waitForVerificationID());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<String> waitForVerificationID() async {
    return verificationIdCompleter.future;
  }

  Future<bool> verifyCode(String code, String userType) async {
    try {
      print(code);
      final String verificationId = await waitForVerificationID();

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _auth.signInWithCredential(credential).then((value) async {
        await _isUserExists(value.user!.uid, userType).then((val) async {
          print(value);
          if (!val) {
            if (kDebugMode) {
              print(val);
            }
            await createCustomer(value.user!.uid, value.user!.phoneNumber!);
          }
        });
      });

      return true;
    } catch (e) {
      print('حدث خطأ أثناء التحقق من رمز التحقق: $e');
      return false;
    }
  }

  Future<bool> _isUserExists(
    String id,
    String userType,
  ) async {
    late bool isExists;
    print(")))))))))))))))))))))))))))))))))))))))))))))))))");
    await _firestore.collection("${userType}s/").doc(id).get().then((value) {
      isExists = value.data() != null;
      print("****************************" + isExists.toString());
    });
    return isExists;
  }

  Future createCustomer(String id, String phone) async {
    try {
      AppUser user = Customer(
          cartItems: [], favorites: [], orders: [], id: id, phone: phone);
      await _firestore.doc("customers/$id)").set(user.toJson()).then((value) {
        print("objectKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
      });
    } catch (e) {
      print(e);
    }
  }
}
