import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/data/services/payment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

class PaymentRepository {
  PaymentService service = PaymentService();

  Future<Either<FirebaseException, bool>> addItem(
      {required String productId, int quantity = 1}) {
    return service.addItem(productId: productId);
  }

  Future<Either<FirebaseException, bool>> editQuantity(
      {required String productId, required int quantity}) {
    return service.editQuantity(productId: productId, quantity: quantity);
  }

  Future<Either<FirebaseException, bool>> removeItem(
      {required String productId}) {
    return service.removeItem(productId: productId);
  }

  Future<PaymentResponse> completePayment(
      {required BuildContext context, required OrderModel order}) {
    return service.completePayment(context: context, order: order);
  }
}
