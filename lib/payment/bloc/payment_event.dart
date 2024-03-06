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

class CompletePaymentCart extends PaymentEvent {
  final BuildContext context;
  final double totalPrice;

  const CompletePaymentCart({
    required this.context,
    required this.totalPrice,
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

class AcceptedOrderForWorkersEvent extends PaymentEvent {
  final OrderForWorkers orderForWorkers;

  const AcceptedOrderForWorkersEvent({required this.orderForWorkers});

  @override
  List<Object?> get props => [orderForWorkers];
}

class IgnoredOrderForWorkersEvent extends PaymentEvent {
  final String orderId;

  const IgnoredOrderForWorkersEvent({
    required this.orderId,
  });

  @override
  List<Object?> get props => [
        orderId,
      ];
}
