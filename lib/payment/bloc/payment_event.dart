part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class AddToCartEvent extends PaymentEvent {
  final String productId;
  final int quantity;

  const AddToCartEvent({required this.productId, this.quantity = 1});

  @override
  List<Object?> get props =>
      [
        productId,
      ];
}

class RemoveFromCart extends PaymentEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object?> get props =>
      [
        productId
      ];
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
  List<Object?> get props =>
      [
        productId
      ];
}

class CompletePaymentCart extends PaymentEvent {
  final BuildContext context;

  final OrderModel order;

  const CompletePaymentCart({required this.context, required this.order});

  @override
  List<Object?> get props =>
      [
        order
      ];
}
