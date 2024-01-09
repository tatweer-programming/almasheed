part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class SendCodeLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class SendCodeErrorState extends AuthState {
  final FirebaseException exception;

  const SendCodeErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class CodeSent extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerifyCodeLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerifyCodeErrorState extends AuthState {
  final FirebaseException exception;

  const VerifyCodeErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class CreateUserErrorState extends AuthState {
  final FirebaseException exception;

  const CreateUserErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class CreateUserSuccessfulState extends AuthState {
  const CreateUserSuccessfulState();

  @override
  List<Object?> get props => [];
}

class CodeVerified extends AuthState {
  @override
  List<Object?> get props => [];
}

class UserNotFoundState extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFailed extends AuthState {
  final String error;

  const AuthFailed({required this.error});

  @override
  List<Object?> get props => [];
}

class ChangeAgreeToTermsState extends AuthState {
  final bool state;

  const ChangeAgreeToTermsState({required this.state});

  @override
  List<Object?> get props => [state];
}

class ChangeIsMerchantTypeState extends AuthState {
  final bool state;

  const ChangeIsMerchantTypeState({required this.state});

  @override
  List<Object?> get props => [state];
}

class SelectAccountTypeState extends AuthState {
  final int index;

  const SelectAccountTypeState({required this.index});

  @override
  List<Object?> get props => [index];
}

class AddAddressLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AddAddressErrorState extends AuthState {
  final FirebaseException exception;

  const AddAddressErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class AddAddressSuccessfulState extends AuthState {
  @override
  List<Object?> get props => [];
}

class RemoveAddressLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class RemoveAddressErrorState extends AuthState {
  final FirebaseException exception;

  const RemoveAddressErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class RemoveAddressSuccessfulState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ChooseAddresTypeState extends AuthState {
  final String addressType;

  const ChooseAddresTypeState({required this.addressType});

  @override
  List<Object?> get props => [addressType];
}

class ChooseCityState extends AuthState {
  final String city;

  const ChooseCityState({required this.city});

  @override
  List<Object?> get props => [city];
}
