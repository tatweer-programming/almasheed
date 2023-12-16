import 'dart:async';

import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool  agreeToTerms = false ;
  bool codeSent = false;
  String ? verificationId = AuthService.verificationID;

  AuthBloc() : super(AuthInitial()){
    AuthRepository repository = AuthRepository();

    on<AuthEvent>((event, emit) async {

      if (event is SendCodeEvent) {


        try {
          // استدعاء دالة إرسال رمز التحقق من AuthServices
          final result = await repository.verifyPhoneNumber(event.phoneNumber);

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

agreeToTerms = !agreeToTerms ;
emit(ChangeAgreeToTermsState(state: agreeToTerms));
      }

   else if (event is VerifyCodeEvent) {
   var result =  repository.verifyCode(event.code , event.userType );
      }
    });
  }
}
