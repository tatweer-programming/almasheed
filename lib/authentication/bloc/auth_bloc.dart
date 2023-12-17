import 'dart:async';

import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/customer.dart';
import '../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static AuthBloc get(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context);
  bool agreeToTerms = false;
  bool codeSent = false;
  String? verificationId = AuthService.verificationID;
   AppUser  ? user;
  late AuthRepository repository;
  AuthBloc() : super(AuthInitial()) {
    repository = AuthRepository();

    on<AuthEvent>((event, emit) async {
      if (event is SendCodeEvent) {
        user = event.user;
        print(event.user.phone);
        print(user?.phone);
        try {
          final result = await repository.verifyPhoneNumber(user!.phone);
          result.fold((l) {}, (r) {
            codeSent = true;
            verificationId = r;
            emit(CodeSent());
          });
        } catch (e) {
          // حدث خطأ، يمكنك إضافة رسالة خطأ إلى حالة الـ BLoC
          //   yield AuthenticationFailed(error: 'حدث خطأ غير متوقع');
        }
      }
      else if (event is ChangeAgreeToTermsStateEvent) {
        agreeToTerms = !agreeToTerms;
        emit(ChangeAgreeToTermsState(state: agreeToTerms));
      }
      else if (event is VerifyCodeEvent) {
        print(user);
        String userType = (user is Customer) ? "customer" : "merchant";
        var result = await repository.verifyCode(event.code, userType);
        result.fold((l) {}, (r) async {
          user?.id = r;
          await _createUser();
        });
      }
    });
  }
  Future _createUser() async {
    var result = await repository.createUser(user!);
    result.fold((l) {}, (r) {});
  }
}
