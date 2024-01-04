import 'dart:async';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/merchant_register_screen.dart';
import 'package:almasheed/authentication/presentation/screens/customer_register_screen.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
  bool isMerchant = false ;
  bool codeSent = false;
  bool authCompleted = false;
  String? verificationId = AuthService.verificationID;
  AppUser? user;
  int ? selectedAccountTypeIndex ;
  late AuthRepository repository;
  List<Widget> registerScreens = const [
    MerchantLoginScreen() ,
    CustomerLoginScreen()
  ];
  AuthBloc() : super(AuthInitial()) {
    repository = AuthRepository();

    on<AuthEvent>((event, emit) async {
      if (event is SendCodeEvent) {

        emit(SendCodeLoadingState());
        user = event.user;
        final result = await repository.verifyPhoneNumber(user!.phone);
        result.fold((l) {
          errorToast(msg: ExceptionManager(l).translatedMessage());
          emit(SendCodeErrorState());
        }, (r) {
          codeSent = true;
          verificationId = r;
          defaultToast(msg: "Code Sent Successfully ");
          emit(CodeSent());
        });
      }
      if (event is LoginByPhoneEvent) {
        String  userType = event.user is Customer ? "customer":"merchant" ;
        emit(SendCodeLoadingState());
        user = event.user;
        final result = await repository.loginByPhone(event.user.phone,
            userType);
        result.fold((l) {
          errorToast(msg: ExceptionManager(l).translatedMessage());
          emit(SendCodeErrorState());
        }, (r) {
      if (r == "NOT_FOUND"){
        errorToast(msg: "User not found");
        emit(UserNotFoundState());
      }
      else{
        codeSent = true;
        verificationId = r;
        defaultToast(msg: "Code Sent Successfully ");
        emit(CodeSent());
      }
        });
      }
      else if (event is ChangeAgreeToTermsStateEvent) {
        agreeToTerms = !agreeToTerms;
        emit(ChangeAgreeToTermsState(state: agreeToTerms));
      }

      else if (event is ChangeIsMerchantTypeStateEvent) {
        isMerchant = !isMerchant;
        emit(ChangeIsMerchantTypeState(state: isMerchant));
      }

      else if (event is VerifyCodeEvent) {
        if (kDebugMode) {
          print(user);
        }
        String userType = (user is Customer) ? "customer" : "merchant";
        var result = await repository.verifyCode(event.code, userType);
        result.fold((l) {
          errorToast(msg: ExceptionManager(l).translatedMessage());
        }, (r) async {
          defaultToast(msg: "Code Verified Successfully");
          user?.id = r;
          await _createUser();
          emit(Authenticated());
        });
      }
      else if (event is SelectAccountTypeEvent) {
        selectedAccountTypeIndex = event.index ;
        emit(SelectAccountTypeState(index: event.index));
      }
      else if (event is NavigateToRegisterScreenEvent) {
     event.context.push(registerScreens[selectedAccountTypeIndex!]);
      }
    });
  }

  Future _createUser() async {
    var result = await repository.createUser(user!);
    result.fold((l) {
      errorToast(msg: ExceptionManager(l).translatedMessage());
    }, (r) async {
      bool isExists = r;
      if (isExists) {
        authCompleted = true;
        ConstantsManager.appUser = user;

        if (kDebugMode) {
          print(ConstantsManager.appUser);
        }
      } else {
        defaultToast(msg: "user created Successfully");
        authCompleted = true;
        ConstantsManager.appUser = user;

        if (kDebugMode) {
          print(ConstantsManager.appUser);
        }
      }
    });
  }

}
