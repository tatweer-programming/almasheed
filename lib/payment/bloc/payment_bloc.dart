import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/data/models/customer.dart';
import '../../core/services/dep_injection.dart';
import '../data/models/orderItem.dart';
import '../data/repositories/payment_repository.dart';

part 'payment_event.dart';

part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  static PaymentBloc bloc = PaymentBloc();

  static PaymentBloc get() => bloc;
  late OrderModel order = OrderModel.create([], null);

  // variables
  final PaymentRepository? _repository =
      ConstantsManager.appUser is Customer ? PaymentRepository() : null;
  int? selectedAddressIndex;

  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) async {
      if (event is AddToCartEvent) {
        emit(AddToCartLoadingState());
        var response =
            await _repository?.addItem(productId: event.productId, quantity: event.quantity);
        response!.fold((l) {
          emit(AddToCartErrorState(l));
        }, (r) {
          emit(AddToCartSuccessState());
        });
      } else if (event is RemoveFromCart) {
        emit(RemoveFromCartLoadingState());
        var response = await _repository!.removeItem(
          productId: event.productId,
        );
        response.fold((l) {
          emit(RemoveFromCartErrorState(l));
        }, (r) {
          emit(RemoveFromCartSuccessState());
        });
      } else if (event is EditQuantityInCart) {
        emit(EditQuantityInCartLoadingState());
        var response =
            await _repository!.editQuantity(productId: event.productId, quantity: event.quantity);
        response.fold((l) {
          emit(EditQuantityInCartErrorState(l));
        }, (r) {
          emit(EditQuantityInCartSuccessState());
        });
      } else if (event is CompletePaymentCart) {
        var response = await _repository!.completePayment(context: event.context, order: order);
        print(response.status.toString() + response.url.toString());
        print(response.toString());
        if (response.isSuccess) {
          await _repository!.saveOrderData(order);
          emit(CompleteOrderSuccessState());
        } else {
          emit(const CompletePaymentErrorState());
        }
      } else if (event is PrepareCart) {
        _generateOrder();
        emit(CartPreparedState());
      } else if (event is ChooseAddress) {
        selectedAddressIndex = event.index;
        Customer customer = ConstantsManager.appUser as Customer;
        order.address = customer.addresses[event.index];
        emit(ChooseAddressState(event.index));
      }
    });
  }

  _generateOrder() {
    MainBloc mainBloc = sl();
    List<OrderItem> orderItems = [];
    Customer customer = ConstantsManager.appUser as Customer;
    print(customer.cartItems.toString());
    customer.cartItems.forEach((key, value) {
      orderItems.add(OrderItem(
          product: mainBloc.products.firstWhere((element) => element.productId == key),
          quantity: value));
    });

    order = OrderModel.create(orderItems, null);
    return order;
  }
}
