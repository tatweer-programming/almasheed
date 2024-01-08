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

class ChangeIsMerchantTypeStateEvent extends AuthEvent {
  final bool state;

  const ChangeIsMerchantTypeStateEvent({required this.state});

  @override
  List<Object?> get props => [];
}

class SelectAccountTypeEvent extends AuthEvent {
  final int index;

  const SelectAccountTypeEvent({required this.index});

  @override
  List<Object?> get props => [];
}

class NavigateToRegisterScreenEvent extends AuthEvent {
  final BuildContext context;
  const NavigateToRegisterScreenEvent(this.context);

  @override
  List<Object?> get props => [];
}

class AddAddressEvent extends AuthEvent {
  final Address address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [];
}

class RemoveAddressEvent extends AuthEvent {
  final Address address;

  const RemoveAddressEvent(this.address);

  @override
  List<Object?> get props => [];
}
