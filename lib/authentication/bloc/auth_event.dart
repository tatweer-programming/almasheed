part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

// authentication_bloc.dart

class SendCodeEvent extends AuthEvent {
  final AppUser user;

  const SendCodeEvent(this.user);

  @override
  List<Object?> get props => [user];
}
class UpdateWorkerEvent extends AuthEvent {
  final Worker worker;

  const UpdateWorkerEvent(this.worker);

  @override
  List<Object?> get props => [worker];
}

class LoginByPhoneEvent extends AuthEvent {
  final AppUser user;

  const LoginByPhoneEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class VerifyCodeEvent extends AuthEvent {
  final String code;

  const VerifyCodeEvent({
    required this.code,
  });

  @override
  List<Object?> get props => [
        code,
      ];
}

class ChangeAgreeToTermsStateEvent extends AuthEvent {
  final bool state;

  const ChangeAgreeToTermsStateEvent({required this.state});

  @override
  List<Object?> get props => [];
}

class ChangeIsMerchantTypeEvent extends AuthEvent {
  final bool state;

  const ChangeIsMerchantTypeEvent({required this.state});

  @override
  List<Object?> get props => [state];
}class ChangeIsWorkerTypeEvent extends AuthEvent {
  final bool state;

  const ChangeIsWorkerTypeEvent({required this.state});

  @override
  List<Object?> get props => [state];
}

class SelectAccountTypeEvent extends AuthEvent {
  final int index;

  const SelectAccountTypeEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class NavigateToRegisterScreenEvent extends AuthEvent {
  final BuildContext context;

  const NavigateToRegisterScreenEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class NavigateToAccountTypesScreenEvent extends AuthEvent {
  final BuildContext context;

  const NavigateToAccountTypesScreenEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class AddAddressEvent extends AuthEvent {
  final Address address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class RemoveAddressEvent extends AuthEvent {
  final Address address;

  const RemoveAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class ChooseAddressTypeEvent extends AuthEvent {
  final String addressType;

  const ChooseAddressTypeEvent(this.addressType);

  @override
  List<Object?> get props => [];
}
class MakeSelectedAccountTypeNullEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ChooseCityEvent extends AuthEvent {
  final String city;

  const ChooseCityEvent(this.city);

  @override
  List<Object?> get props => [city];
}class ChooseWorkEvent extends AuthEvent {
  final List<String> works;

  const ChooseWorkEvent(this.works);

  @override
  List<Object?> get props => [works];
}

class StartResendCodeTimerEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ResetCodeTimerEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfilePictureEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
