part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class PrepareCart extends PaymentEvent {
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends PaymentEvent {
  final String productId;
  final int? quantity;

  const AddToCartEvent({required this.productId, this.quantity});

  @override
  List<Object?> get props => [
        productId,
      ];
}

class RemoveFromCart extends PaymentEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends PaymentEvent {
  @override
  List<Object?> get props => [];
}

class EditQuantityInCart extends PaymentEvent {
  final String productId;
  final int quantity;

  const EditQuantityInCart({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId];
}

//ignore: must_be_immutable
class CompletePaymentCart extends PaymentEvent {
  final BuildContext context;
  final double totalPrice;
  OrderForWorkers? orderForWorkers;

  CompletePaymentCart({
    required this.context,
    required this.totalPrice,
    this.orderForWorkers,
  });

  @override
  List<Object?> get props => [];
}

class ChooseAddress extends PaymentEvent {
  final int index;

  const ChooseAddress(this.index);

  @override
  List<Object?> get props => [index];
}

class GetUserOrders extends PaymentEvent {
  @override
  List<Object?> get props => [];
}

class CreateChatAndDeleteOrderForWorkersEvent extends PaymentEvent {
  final BuildContext context;

  const CreateChatAndDeleteOrderForWorkersEvent(this.context);

  @override
  List<Object?> get props => [];
}

class AcceptedOrderForWorkersEvent extends PaymentEvent {
  final OrderForWorkers orderForWorkers;
  final List<OrderForWorkers> ordersForWorkers;

  const AcceptedOrderForWorkersEvent({
    required this.orderForWorkers,
    required this.ordersForWorkers,
  });

  @override
  List<Object?> get props => [orderForWorkers];
}

class IgnoredOrderForWorkersEvent extends PaymentEvent {
  final OrderForWorkers orderForWorkers;
  final List<OrderForWorkers> ordersForWorkers;

  const IgnoredOrderForWorkersEvent({
    required this.orderForWorkers,
    required this.ordersForWorkers,
  });

  @override
  List<Object?> get props => [
        orderForWorkers,
      ];
}

class RemoveOrderForWorkersEvent extends PaymentEvent {
  final OrderForWorkers orderForWorkers;

  const RemoveOrderForWorkersEvent({
    required this.orderForWorkers,
  });

  @override
  List<Object?> get props => [
        orderForWorkers,
      ];
}
/*
[Music]

 */
