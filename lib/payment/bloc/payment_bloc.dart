import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      ConstantsManager.appUser is! Merchant ? PaymentRepository() : null;
  int? selectedAddressIndex;

  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) async {
      if (event is AddToCartEvent) {
        emit(AddToCartLoadingState());
        var response = await _repository?.addItem(
            productId: event.productId, quantity: event.quantity ?? 1);
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
        var response = await _repository!
            .editQuantity(productId: event.productId, quantity: event.quantity);
        response.fold((l) {
          emit(EditQuantityInCartErrorState(l));
        }, (r) {
          emit(EditQuantityInCartSuccessState());
        });
      } else if (event is CompletePaymentCart) {
        var response = await _repository!.completePayment(
            context: event.context, totalPrice: event.totalPrice);
        print(response.status.toString() + response.url.toString());
        print(response.toString());
        print(order);
        if (response.isSuccess) {
          if (event.orderForWorkers != null) {
            await _repository!.createChatAndDeleteOrder(event.orderForWorkers!);
          } else {
            await _repository!.saveOrderData(order);
          }
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
      } else if (event is AcceptedOrderForWorkersEvent) {
        emit(AcceptedOrderForWorkersLoadingState());
        var result = await _repository!.acceptedOrderForWorkers(
          orderForWorkers: event.orderForWorkers,
        );
        result.fold((l) {
          emit(AcceptedOrderForWorkersErrorState(l));
        }, (r) {
          emit(AcceptedOrderForWorkersSuccessfullyState());
        });
      } else if (event is IgnoredOrderForWorkersEvent) {
        emit(IgnoredOrderForWorkersLoadingState());
        var result = await _repository!.ignoredOrderForWorkers(
          orderId: event.orderId,
        );
        result.fold((l) {
          emit(IgnoredOrderForWorkersErrorState(l));
        }, (r) {
          emit(IgnoredOrderForWorkersSuccessfullyState());
        });
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
          product: mainBloc.products
              .firstWhere((element) => element.productId == key),
          quantity: value));
    });

    order = OrderModel.create(orderItems, null);
    return order;
  }
}
