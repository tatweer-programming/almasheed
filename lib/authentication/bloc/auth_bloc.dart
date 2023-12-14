import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool  agreeToTerms = false ;
  bool codeSent = false;
  AuthBloc() : super(AuthInitial()) {
    AuthRepository repository = AuthRepository();

    on<AuthEvent>((event, emit) async {

      if (event is SendCodeEvent) {


        try {
          // استدعاء دالة إرسال رمز التحقق من AuthServices
          final result = await repository.verifyPhoneNumber(event.phoneNumber);

          if (result) {
          codeSent = true;
            emit(CodeSent());
          } else {

          }
        } catch (e) {
          // حدث خطأ، يمكنك إضافة رسالة خطأ إلى حالة الـ BLoC
          //   yield AuthenticationFailed(error: 'حدث خطأ غير متوقع');
        }
      }

     else if (event is ChangeAgreeToTermsStateEvent) {

agreeToTerms = !agreeToTerms ;
emit(ChangeAgreeToTermsState(state: agreeToTerms));
      }

   else if (event is VerifyCodeEvent) {
   var result =  repository.verifyCode(event.code);
      }
    });
  }
}
