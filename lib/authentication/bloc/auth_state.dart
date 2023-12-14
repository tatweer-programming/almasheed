part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
// authentication_bloc.dart

class CodeSent extends AuthState {
  @override
  List<Object?> get props => [];
}

class CodeVerified extends AuthState {
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

class ChangeAgreeToTermsState  extends AuthState {
  final bool state;

  const ChangeAgreeToTermsState ({required this.state});
  @override
  List<Object?> get props => [state];
}
