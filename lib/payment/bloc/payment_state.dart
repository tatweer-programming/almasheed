part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
}

class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}

class AddToCartLoadingState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class AddToCartSuccessState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class AddToCartErrorState extends PaymentState {
  final FirebaseException exception;
  const AddToCartErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class RemoveFromCartLoadingState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class RemoveFromCartSuccessState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class RemoveFromCartErrorState extends PaymentState {
  final FirebaseException exception;
  const RemoveFromCartErrorState(this.exception);
  @override
  List<Object?> get props => [exception];
}

class EditQuantityInCartLoadingState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class EditQuantityInCartSuccessState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class EditQuantityInCartErrorState extends PaymentState {
  final FirebaseException exception;
  const EditQuantityInCartErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class ClearCartLoadingState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class ClearCartSuccessState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class ClearCartErrorState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class CompleteOrderLoadingState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class CompleteOrderSuccessState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class CartPreparedState extends PaymentState {
  @override
  List<Object?> get props => [];
}

class CompleteOrderErrorState extends PaymentState {
  final FirebaseException exception;

  const CompleteOrderErrorState(this.exception);

  @override
  List<Object?> get props => [exception];
}

class ChooseAddressState extends PaymentState {
  final int index;

  const ChooseAddressState(this.index);

  @override
  List<Object?> get props => [index];
}
