
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/payment_repository.dart';

part 'payment_event.dart';

part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository = PaymentRepository();

  static PaymentBloc get(BuildContext context) =>
      BlocProvider.of<PaymentBloc>(context);

  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) async {
      if (event is AddToCartEvent) {
        emit(AddToCartLoadingState());
        var response = await _repository.addItem(
            productId: event.productId, quantity: event.quantity);
        response.fold((l) {
          emit(AddToCartErrorState());
          errorToast(msg: "");
        }, (r) {
          defaultToast(msg: "added Successfully");
          emit(AddToCartSuccessState());
        });
      } else if (event is RemoveFromCart) {
        emit(RemoveFromCartLoadingState());
        var response = await _repository.removeItem(
          productId: event.productId,
        );
        response.fold((l) {
          emit(RemoveFromCartErrorState());
          errorToast(msg: "");
        }, (r) {
          defaultToast(msg: "added Successfully");
          emit(RemoveFromCartSuccessState());
        });
      } else if (event is EditQuantityInCart) {
        emit(EditQuantityInCartLoadingState());
        var response = await _repository.editQuantity(
            productId: event.productId, quantity: event.quantity);
        response.fold((l) {
          emit(EditQuantityInCartErrorState());
          errorToast(msg: "");
        }, (r) {
          defaultToast(msg: "added Successfully");
          emit(EditQuantityInCartSuccessState());
        });
      } else if (event is ClearCart) {
        emit(ClearCartLoadingState());
        var response = await _repository.clearCart();
        response.fold((l) {
          emit(ClearCartErrorState());
          errorToast(msg: "");
        }, (r) {
          defaultToast(msg: "added Successfully");
          emit(ClearCartSuccessState());
        });
      } else if (event is CompletePaymentCart) {
        var response = await _repository.completePayment(
            context: event.context, order: event.order);
      }
    });
  }
}
