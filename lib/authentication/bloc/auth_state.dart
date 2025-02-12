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

class ResetCodeTimerState extends AuthState {
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

class LoginLoadingState extends AuthState {
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
}class CreateUserLoadingState extends AuthState {
  const CreateUserLoadingState();

  @override
  List<Object?> get props => [];
}

class CodeVerifiedState extends AuthState {
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

class ChangeIsWorkerTypeState extends AuthState {
  final bool state;

  const ChangeIsWorkerTypeState({required this.state});

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

class UpdateWorkerLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdateWorkerErrorState extends AuthState {
  final FirebaseException exception;

  const UpdateWorkerErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class UpdateWorkerSuccessfulState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ChooseAddressTypeState extends AuthState {
  final String addressType;

  const ChooseAddressTypeState({required this.addressType});

  @override
  List<Object?> get props => [addressType];
}

class ChooseCityState extends AuthState {
  final String city;

  const ChooseCityState({required this.city});

  @override
  List<Object?> get props => [city];
}

class ChooseWorkState extends AuthState {
  final List<String> works;

  const ChooseWorkState({required this.works});

  @override
  List<Object?> get props => [works];
}

class ChangeTimeToResendCodeState extends AuthState {
  final int time;

  const ChangeTimeToResendCodeState({required this.time});

  @override
  List<Object?> get props => [time];
}

class LogoutLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LogoutErrorState extends AuthState {
  final FirebaseException exception;

  const LogoutErrorState(this.exception);

  @override
  List<Object?> get props => [];
}

class LogoutSuccessfulState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileSuccessState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileErrorState extends AuthState {
  final Exception exception;
  const UpdateProfileErrorState(this.exception);
  @override
  List<Object?> get props => [];
}
class DeleteAccountLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}
class DeleteAccountErrorState extends AuthState {
  final Exception exception;
  const DeleteAccountErrorState(this.exception);
  @override
  List<Object?> get props => [];
}
class ShowDialogState extends AuthState {
  @override
  List<Object?> get props => [];
}
class DeleteAccountSuccessfulState extends AuthState {
  @override
  List<Object?> get props => [];
}
