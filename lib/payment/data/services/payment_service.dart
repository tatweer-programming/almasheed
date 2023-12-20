import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

class PaymentService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<Either<FirebaseException, bool>> addItem(
      {required Product product}) async {
    Customer customer = ConstantsManager.appUser as Customer;
    customer.cartItems[''];
    try {
      fireStore.doc('customers/${ConstantsManager.appUser!.id}').update({
        'cart': FieldValue.arrayUnion([product.productId])
      });
      return const Right(true);
    } on FirebaseException catch (e) {
      customer.cartItems.remove(product.productId);
      return Left(e);
    }
  }

  Future<Either<FirebaseException, bool>> removeItem(
      {required Product product}) async {
    Customer customer = ConstantsManager.appUser as Customer;
    customer.cartItems.remove(product.productId);
    try {
      fireStore.doc('customers/${ConstantsManager.appUser!.id}').update({
        'cart': FieldValue.arrayRemove([product.productId])
      });
      return const Right(true);
    } on FirebaseException catch (e) {
      customer.cartItems['add(product.productId)'];
      return Left(e);
    }
  }

  Future<Either<FirebaseException, bool>> clearCart() async {
    Customer customer = ConstantsManager.appUser as Customer;

    try {
      fireStore
          .doc('customers/${ConstantsManager.appUser!.id}')
          .update({'cart': []});
      customer.cartItems.clear();
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<PaymentResponse> completePayment(
      {required BuildContext context, required OrderModel order}) async {
    return MyFatoorah.startPayment(
      afterPaymentBehaviour: AfterPaymentBehaviour.AfterCallbackExecution,
      context: context,
      request: MyfatoorahRequest.test(
        initiatePaymentUrl: "https://sa.myfatoorah.com/",
        currencyIso: Country.SaudiArabia,
        successUrl: "https://www.google.com",
        errorUrl: "https://www.youtube.com/",
        invoiceAmount: order.totalPrice * 10,
        language: ApiLanguage.Arabic,
        token:
            "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
      ),
    );
  }
}
