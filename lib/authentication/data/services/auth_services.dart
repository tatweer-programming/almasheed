import 'dart:async';
import 'dart:io';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/core/local/shared_prefrences.dart';
import 'package:almasheed/core/services/dep_injection.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<Either<FirebaseAuthException, String>> verifyPhoneNumber(String phoneNumber) async {
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

  Future<Either<FirebaseAuthException, String>> verifyCode(String code, String userType) async {
    try {
      String? id;
      final String verificationId = await waitForVerificationID();

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _firebaseAuth.signInWithCredential(credential).then((value) async {
        id = value.user!.uid;
        await FirebaseMessaging.instance.subscribeToTopic("$id").then((value) async {
          await CacheHelper.saveData(key: "isNotificationsOn", value: true);
        });
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
    await _fireStore.collection("${userType}s/").doc(id).get().then((value) async {
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
      isUserExists ? DoNothingAction() : await _addUSerToFireStore(user, userType);
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
      await _fireStore.collection("${customer.getType()}s").doc(customer.id).update({
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
      await _fireStore.collection("${customer.getType()}s").doc(customer.id).update({
        "addresses": FieldValue.arrayRemove([address.toJson()])
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<Either<FirebaseException, Unit>> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut().then((value) async {
        await _clearUserData(context);
      });
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  Future<Either<FirebaseException, String>> uploadProfilePic(File newImage) async {
    try {
      String newImageUrl = await _uploadNewImage(newImage);
      ConstantsManager.appUser?.image = newImageUrl;
      return Right(newImageUrl);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future updateImageInFireStore(String newImageUrl) async {
    _fireStore
        .doc("${ConstantsManager.appUser?.getType()}s/${ConstantsManager.userId}")
        .update({"image": newImageUrl});
  }

  Future deleteOldPic(String url) async {
    try {
      Reference firebaseStorageRef = FirebaseStorage.instance.refFromURL(url);
      await firebaseStorageRef.delete();
    } catch (e) {
      return Left(e);
    }
  }

  Future<String> _uploadNewImage(File newImage) async {
    try {
      String fileExtension = newImage.path.split(".").last;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'profiles/${ConstantsManager.appUser!.getType()}s/${ConstantsManager.userId}.$fileExtension');
      UploadTask uploadTask = firebaseStorageRef.putFile(newImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return '';
    }
  }

  Future _clearUserData(BuildContext context) async {
    ChatBloc chatBloc = ChatBloc.get(context);
    chatBloc.chats = [];
    MainBloc mainBloc = sl();
    mainBloc.pageIndex = 0;
    mainBloc.carouselIndicatorIndex = 0;
    mainBloc.products = [];
    mainBloc.lastSeenProducts = {};
    mainBloc.merchants = [];
    mainBloc.workers = [];
    mainBloc.ordersForWorkers = [];
    mainBloc.offers = [];
    mainBloc.bestSales = [];
    mainBloc.categories = [];
    mainBloc.imagesFiles = [];
    mainBloc.sortedProducts = [];
    mainBloc.selectedProperties = [];
    ConstantsManager.appUser = null;
    ConstantsManager.userType = null;
    ConstantsManager.registrationSkipped = null;
    ConstantsManager.userId = null;
    await CacheHelper.removeData(key: "userId");
    await CacheHelper.removeData(key: "userType");
  }

  Future _addUSerToFireStore(AppUser user, String userType) async {
    try {
      await _fireStore.doc("${userType}s/${user.id}").set(user.toJson()).then((value) async {
        await _saveUser(user, userType);
      });
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  Future<Either<FirebaseException, Unit>> updateWorker(Worker worker) async {
    try {
      await _fireStore
          .collection("workers")
          .doc(ConstantsManager.userId!)
          .update(worker.toJson())
          .then((value) async {});
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> deleteAccount(BuildContext context) async {
    try {
      final user = ConstantsManager.appUser!;

      // 1. Delete user from Firebase Authentication
      await _firebaseAuth.currentUser!.delete();
      // 2. Delete user from FireStore
      await _deleteUserFromFireStore();

      // 3. Delete related data based on user type
      if (user is Merchant) {
        await _deleteMerchantData();
      } else if (user is Customer) {
        await _deleteCustomerData();
      } else if (user is Worker) {
        // احذف بيانات العامل اللي تحبها براحتك
      }
      await _clearUserData(context);
      return const Right(unit);
    } on Exception catch (e) {
      print('Error deleting account: $e');
      return Left(e);
    }
  }

  Future<void> _deleteUserFromFireStore() async {
    await _fireStore
        .collection("${ConstantsManager.appUser!.getType()}s")
        .doc(ConstantsManager.userId)
        .delete();
  }

  Future<void> _deleteMerchantData() async {
    Merchant merchant = ConstantsManager.appUser! as Merchant;
    List<String> productIds = merchant.productsIds;
    // Delete products
    for (String productId in productIds) {
      await _fireStore.collection('products').doc(productId).delete();
    }

    // Delete best sales
    final bestSalesDoc = await _fireStore.collection('best_sales').doc('best_sales').get();
    final Map<String, dynamic> bestSalesData = bestSalesDoc.data()!;
    for (String productId in productIds) {
      if (bestSalesData.containsKey(productId)) {
        await _fireStore
            .collection('best_sales')
            .doc('best_sales')
            .update({productId: FieldValue.delete()});
      }
    }

    // Delete offers
    final offersDoc = await _fireStore.collection('offers').doc('offers').get();
    final List<dynamic> offersData = offersDoc.data()!['productsIds'];
    offersData.removeWhere((id) => productIds.contains(id));
    await _fireStore.collection('offers').doc('offers').update({'productsIds': offersData});

    // Delete products from categories
    final categoriesQuery = await _fireStore
        .collection('categories')
        .where('productsIds', arrayContainsAny: productIds)
        .get();
    for (var categoryDoc in categoriesQuery.docs) {
      final categoryData = categoryDoc.data();
      final List<dynamic> categoryProductsIds = categoryData['productsIds'] ?? [];
      final updatedProductIds = List.from(categoryProductsIds)
        ..removeWhere((id) => productIds.contains(id));
      await _fireStore
          .collection('categories')
          .doc(categoryDoc.id)
          .update({'productsIds': updatedProductIds});
    }
  }

  Future<void> _deleteCustomerData() async {
    String userId = ConstantsManager.userId!;
    // Delete orders
    final ordersQuery =
        await _fireStore.collection('orders').where('customerId', isEqualTo: userId).get();
    for (var doc in ordersQuery.docs) {
      await doc.reference.delete();
    }

    // Delete orders for workers
    final ordersForWorkersQuery = await _fireStore
        .collection('orders_for_workers')
        .where('customerId', isEqualTo: userId)
        .get();
    for (var doc in ordersForWorkersQuery.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> _searchForUsersByPhoneNumber(String phone, String userType) async {
    var res = await _fireStore.collection("${userType}s").where("phone", isEqualTo: phone).get();
    return res.docs.isNotEmpty;
  }

  Future<void> _saveUser(AppUser user, String userType) async {
    await CacheHelper.saveData(key: "userId", value: user.id);
    await CacheHelper.saveData(key: "userType", value: userType);
    ConstantsManager.userId = user.id;
    ConstantsManager.userType = user.getType();
    ConstantsManager.appUser = user;
  }

  // verify phone required functions
  void _codeAutoRetrievalTimeout(String verificationId) {
    if (kDebugMode) {}
  }

  void handleCodeSentCase(String verificationId, int? resendToken) {
    verificationID = verificationId;
    verificationIdCompleter.complete(verificationID);
    verifyPhoneCompleter.complete(Right(verificationId));
  }

  void _handleVerificationCompleted(PhoneAuthCredential credential) {
    if (kDebugMode) {}
  }

  _handleVerificationFailed(FirebaseAuthException e) {
    if (kDebugMode) {}
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
