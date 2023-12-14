import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
   final FirebaseAuth _auth = FirebaseAuth.instance;
late String verificationID ;

   Future<bool> verifyPhoneNumber(String phoneNumber) async {
     try {
       await _auth.verifyPhoneNumber(
         phoneNumber: phoneNumber,
         verificationCompleted: (PhoneAuthCredential credential) async {

         },
         verificationFailed: (FirebaseAuthException e) {
           print('فشل التحقق: ${e.message}');
         },
         codeSent: (String verificationId, int? resendToken) {
           print('تم إرسال رمز التحقق');
         },
         codeAutoRetrievalTimeout: (String verificationId) {
           print('انتهت مهلة رمز التحقق');
         },
       );
       return true;
     } catch (e) {
       print('حدث خطأ أثناء إرسال رمز التحقق: $e');
       return false;
     }
   }

   Future<bool> verifyCode(String code) async {
    try {
      // إنشاء PhoneAuthCredential باستخدام verificationId ورمز التحقق
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID,
        smsCode: code,
      );

      await _auth.signInWithCredential(credential);

      return true;
    } catch (e) {
      print('حدث خطأ أثناء التحقق من رمز التحقق: $e');
      return false;
    }
  }

    //  Future<Either<bool , String>>  createUser ({required String id ,})async {}

}