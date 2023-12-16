part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

// authentication_bloc.dart



class SendCodeEvent extends AuthEvent {
 final String phoneNumber ;
  const SendCodeEvent(this.phoneNumber);
  @override

  List<Object?> get props =>[];
}

class VerifyCodeEvent extends AuthEvent {
  final String code;
  final String userType ;
  const VerifyCodeEvent({required this.code , required this.userType});

  @override

  List<Object?> get props =>[code , userType];
}


class ChangeAgreeToTermsStateEvent extends AuthEvent {
  final bool state;

  const ChangeAgreeToTermsStateEvent({required this.state});

  @override

  List<Object?> get props =>[];
}