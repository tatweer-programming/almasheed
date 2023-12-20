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
  @override
  List<Object?> get props => [];
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
