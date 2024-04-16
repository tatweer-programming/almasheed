import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/data/services/payment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

class PaymentRepository {
  PaymentService service = PaymentService();

  Future<Either<FirebaseException, bool>> addItem(
      {required String productId, required int quantity}) {
    return service.addItem(productId: productId, quantity: quantity);
  }

  Future<Either<FirebaseException, bool>> editQuantity(
      {required String productId, required int quantity}) {
    return service.editQuantity(productId: productId, quantity: quantity);
  }

  Future<Either<FirebaseException, bool>> removeItem(
      {required String productId}) {
    return service.removeItem(productId: productId);
  }

  Future<PaymentResponse> completePayment({
    required BuildContext context,
    required double totalPrice,
  }) {
    return service.completePayment(
      context: context,
      totalPrice: totalPrice,
    );
  }

  Future<Either<FirebaseException, Unit>> saveOrderData(
      OrderModel order) async {
    return service.saveOrderData(order);
  }

  Future<Either<FirebaseException, Unit>> createChatAndDeleteOrder(
      OrderForWorkers orderForWorkers) async {
    return service.createChatAndDeleteOrder(orderForWorkers);
  }

  Future<Either<FirebaseException, Unit>> acceptedOrderForWorkers({
    required OrderForWorkers orderForWorkers,
  }) async {
    return await service.acceptedOrderForWorkers(
      orderForWorkers: orderForWorkers,
    );
  }

  Future<Either<FirebaseException, Unit>> ignoredOrderForWorkers({
    required String orderId,
  }) async {
    return await service.ignoreOrderForWorkers(
      orderId: orderId,
    );
  }
}
