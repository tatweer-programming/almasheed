import 'dart:async';
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/merchant_register_screen.dart';
import 'package:almasheed/authentication/presentation/screens/customer_register_screen.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/customer.dart';
import '../data/repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static AuthBloc bloc = AuthBloc();

  static AuthBloc get(BuildContext context) => bloc;
  bool agreeToTerms = false;
  bool isMerchant = false;

  bool codeSent = false;
  bool authCompleted = false;
  String? verificationId = AuthService.verificationID;

  int? selectedAccountTypeIndex;

  late AuthRepository repository;
  List<Widget> registerScreens = const [
    MerchantLoginScreen(),
    CustomerLoginScreen()
  ];

  AuthBloc() : super(AuthInitial()) {
    repository = AuthRepository();

    on<AuthEvent>((event, emit) async {
      if (event is SendCodeEvent) {
        emit(SendCodeLoadingState());
        ConstantsManager.appUser = event.user;
        final result =
            await repository.verifyPhoneNumber(ConstantsManager.appUser!.phone);
        result.fold((l) {
          emit(SendCodeErrorState(l));
        }, (r) {
          codeSent = true;
          verificationId = r;
          emit(CodeSent());
        });
      }
      if (event is LoginByPhoneEvent) {
        ConstantsManager.appUser = event.user;
        String userType = event.user is Customer ? "customer" : "merchant";
        emit(SendCodeLoadingState());
        final result =
            await repository.loginByPhone(event.user.phone, userType);
        result.fold((l) {
          emit(SendCodeErrorState(l));
        }, (r) {
          if (r == "NOT_FOUND") {
            emit(UserNotFoundState());
          } else {
            add(SendCodeEvent(ConstantsManager.appUser!));
            emit(CodeSent());
          }
        });
      } else if (event is ChangeAgreeToTermsStateEvent) {
        agreeToTerms = !agreeToTerms;
        emit(ChangeAgreeToTermsState(state: agreeToTerms));
      } else if (event is ChangeIsMerchantTypeStateEvent) {
        isMerchant = !isMerchant;
        emit(ChangeIsMerchantTypeState(state: isMerchant));
      } else if (event is VerifyCodeEvent) {
        emit(VerifyCodeLoadingState());
        if (kDebugMode) {
          print(ConstantsManager.appUser);
        }
        String userType =
            (ConstantsManager.appUser is Customer) ? "customer" : "merchant";
        var result = await repository.verifyCode(event.code, userType);
        result.fold((l) {
          emit(VerifyCodeErrorState(l));
        }, (r) async {
          emit(CodeVerified());
          ConstantsManager.appUser?.id = r;
          await _createUser();
        });
      } else if (event is SelectAccountTypeEvent) {
        selectedAccountTypeIndex = event.index;
        emit(SelectAccountTypeState(index: event.index));
      } else if (event is NavigateToRegisterScreenEvent) {
        event.context.push(registerScreens[selectedAccountTypeIndex!]);
      }
    });
  }

  Future _createUser() async {
    var result = await repository.createUser(ConstantsManager.appUser!);
    result.fold((l) {
      errorToast(msg: ExceptionManager(l).translatedMessage());
      emit(CreateUserErrorState(l));
    }, (r) async {
      bool isExists = r;
      if (isExists) {
        authCompleted = true;

        emit(Authenticated());
        if (kDebugMode) {
          print(ConstantsManager.appUser);
        }
      } else {
        authCompleted = true;
        if (kDebugMode) {
          print(ConstantsManager.appUser);
        }
        emit(const CreateUserSuccessfulState());
      }
    });
  }
}
