import 'dart:convert';

import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../../../chat/data/models/chat.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Customer? customer = ConstantsManager.appUser is Customer
      ? (ConstantsManager.appUser as Customer)
      : null;

  Future<Either<FirebaseException, bool>> addItem(
      {required String productId, required int quantity}) async {
    try {
      customer!.cartItems[productId] = quantity;
      await _updateCartInFireStore();
      return const Right(true);
    } on FirebaseException catch (e) {
      customer!.cartItems.remove(productId);
      return Left(e);
    }
  }

  Future<Either<FirebaseException, bool>> editQuantity(
      {required String productId, required int quantity}) async {
    try {
      customer!.cartItems[productId] = quantity;
      await _updateCartInFireStore();
      return const Right(true);
    } on FirebaseException catch (e) {
      customer!.cartItems.remove(productId);
      return Left(e);
    }
  }

  Future<Either<FirebaseException, bool>> removeItem(
      {required String productId}) async {
    try {
      customer!.cartItems.remove(productId);
      await _updateCartInFireStore();
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<PaymentResponse> completePayment(
      {required BuildContext context, required double totalPrice}) async {
    return await MyFatoorah.startPayment(
      context: context,
      request: MyfatoorahRequest.test(
        currencyIso: Country.SaudiArabia,
        successUrl: ConstantsManager.successUrl,
        errorUrl: ConstantsManager.errorUrl,
        invoiceAmount: totalPrice,
        language: ApiLanguage.Arabic,
        token:
            "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
      ),
    );
  }

  Future<Either<FirebaseException, Unit>> acceptedOrderForWorkers({
    required OrderForWorkers orderForWorkers,
  }) async {
    try {
      var batch = fireStore.batch();
      var orders = fireStore
          .collection("orders_for_workers")
          .doc(orderForWorkers.orderId);
      batch.update(orders, {
        "accepted": true,
      });
      for (var workerId in orderForWorkers.workersIds) {
        var workers = fireStore.collection("workers").doc(workerId);
        batch.update(workers, {
          "ordersIds": FieldValue.arrayRemove([orderForWorkers.orderId])
        });

        if (ConstantsManager.userId! != workerId) {
          batch.update(orders, {
            "workersIds": FieldValue.arrayRemove([workerId])
          });
        }
      }
      await _pushNotification(
          id: orderForWorkers.customerId, name: orderForWorkers.customerName);
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Unit>> ignoreOrderForWorkers({
    required String orderId,
  }) async {
    try {
      var batch = fireStore.batch();
      var orders = fireStore.collection("orders_for_workers").doc(orderId);
      batch.update(orders, {
        "workersIds": FieldValue.arrayRemove([ConstantsManager.userId])
      });
      var workers =
          fireStore.collection("workers").doc(ConstantsManager.userId);
      batch.update(workers, {
        "ordersIds": FieldValue.arrayRemove([orderId])
      });
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future _updateCartInFireStore() async {
    await fireStore
        .doc('customers/${customer!.id}')
        .update({'cartItems': customer?.cartItems});
  }

  Future<Either<FirebaseException, Unit>> saveOrderData(
      OrderModel order) async {
    try {
      var batch = fireStore.batch();
      _saveOrderToFireStore(order, batch);
      _saveOrderIdToUserOrders(order, batch);
      _saveOrderIdToMerchantsOrders(order, batch);
      _createOrderChats(batch: batch, order: order);
      _clearCart(batch);
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<Either<FirebaseException, Unit>> createChatAndDeleteOrder(
      OrderForWorkers orderForWorkers) async {
    try {
      var batch = fireStore.batch();
      var order = fireStore
          .collection("orders_for_workers")
          .doc(orderForWorkers.orderId);
      batch.delete(order);
      await _createChat(
        chat: Chat(
            receiverId: orderForWorkers.customerId,
            receiverName: orderForWorkers.customerName,
            isEnd: false,
            isMerchant: false),
        batch: batch,
      );
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  _saveOrderToFireStore(OrderModel order, WriteBatch batch) async {
    batch.set(fireStore.doc("orders/${order.id}"), order.toJson());
  }

  _clearCart(WriteBatch batch) async {
    batch.update(fireStore.doc("customers/${customer?.id}"), {"cartItems": {}});
    customer?.cartItems.clear();
  }

  _saveOrderIdToUserOrders(OrderModel order, WriteBatch batch) async {
    batch.update(fireStore.doc("customers/${customer?.id}"), {
      "orders": FieldValue.arrayUnion([order.id])
    });
  }

  _saveOrderIdToMerchantsOrders(OrderModel order, WriteBatch batch) async {
    for (var element in order.merchantIds) {
      batch.update(fireStore.doc("merchants/$element"), {
        "orders": FieldValue.arrayUnion([order.id])
      });
    }
  }

  _createOrderChats(
      {required WriteBatch batch, required OrderModel order}) async {
    for (var element in order.merchantIds) {
      var chat = Chat(
        receiverId: element,
        isEnd: false,
        receiverName: order.orderItems
            .firstWhere((item) => item.product.merchantId == element)
            .product
            .merchantName,
        isMerchant: true,
      );
      _createChat(
        chat: chat,
        batch: batch,
      );
    }
  }

  Future<Either<FirebaseException, Unit>> _createChat({
    required Chat chat,
    required WriteBatch batch,
  }) async {
    try {
      var setInSender = fireStore
          .collection("customers")
          .doc(ConstantsManager.appUser!.id)
          .collection("chats")
          .doc(chat.receiverId);
      batch.set(setInSender, chat.toJson());

      Chat chatReceiver = Chat(
        receiverId: ConstantsManager.userId!,
        isMerchant: chat.isMerchant,
        isEnd: chat.isEnd,
        receiverName: (ConstantsManager.appUser! as Customer).name,
      );

      var setInReceiver = fireStore
          .collection(chat.isMerchant ? "merchants" : "workers")
          .doc(chat.receiverId)
          .collection("chats")
          .doc(ConstantsManager.userId);

      batch.set(setInReceiver, chatReceiver.toJson());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<void> _pushNotification({
    required String id,
    required String name,
  }) async {
    await http.post(Uri.parse(ConstantsManager.baseUrlNotification),
        body: jsonEncode({
          "to": "/topics/$id",
          "notification": {
            "body": "تم قبول طلبك ادفع لإكمال العملية",
            "title": name,
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        }),
        headers: {
          "Authorization": "key=${ConstantsManager.firebaseMessagingAPI}",
          "Content-Type": "application/json"
        });
  }
}

// Future<Either<FirebaseException , Unit>> completeOrder(OrderModel order) async
// {
// // save order to firestore
// // clear cart
// // save orderId to user orders
//   // add orderId to merchants orders
//     try{
//       var batch = fireStore.batch();
//       batch.set(fireStore.doc("orders/${DateTime.now()}"), );
//     }
//         on FirebaseException catch (e){
//       return Left(e);
//         }
// }
