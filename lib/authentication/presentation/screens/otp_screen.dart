import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/assets_manager.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/error/remote_error.dart';
import '../../../generated/l10n.dart';
import '../../bloc/auth_bloc.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final otpController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);
    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is CodeVerified) {
          defaultToast(msg: S.of(context).codeVerified);
        } else if (state is UserNotFoundState) {
          errorToast(msg: S.of(context).userNotFound);
        } else if (state is VerifyCodeErrorState) {
          errorToast(
              msg: ExceptionManager(state.exception).translatedMessage());
        } else if (state is CreateUserSuccessfulState) {
          defaultToast(msg: S.of(context).userCreated);
          context.push(const MainScreen());
        } else if (state is CreateUserErrorState) {
          errorToast(
              msg: ExceptionManager(state.exception).translatedMessage());
        } else if (state is Authenticated) {
          print("authenticated");
          context.push(const MainScreen());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: AuthBackground(
                    imagePath: AssetsManager.building_3,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: ListView(
                        children: [
                          const SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              S.of(context).phoneNumberVerification,
                              style: const TextStyle(
                                  color: ColorManager.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8),
                            child: RichText(
                              text: TextSpan(
                                  text: S.of(context).enterSentCode,
                                  children: [
                                    TextSpan(
                                        text: ConstantsManager.appUser?.phone,
                                        style: const TextStyle(
                                            color: ColorManager.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                  style: const TextStyle(
                                      color: ColorManager.white, fontSize: 15)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 30),
                                child: PinCodeTextField(
                                  appContext: context,
                                  length: 6,
                                  animationType: AnimationType.fade,
                                  validator: (v) {
                                    if (v!.length < 6) {
                                      return S.of(context).enterAllCode;
                                    } else {
                                      return null;
                                    }
                                  },
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: ColorManager.white,
                                      inactiveFillColor: ColorManager.white),
                                  cursorColor: ColorManager.black,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  controller: otpController,
                                  keyboardType: TextInputType.number,
                                  onCompleted: (v) {
                                    bloc.add(VerifyCodeEvent(
                                      code: otpController.text,
                                    ));
                                    print("Completed");
                                  },
                                  onChanged: (value) {},
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).didNotReceiveCode,
                                style: const TextStyle(
                                    color: ColorManager.white, fontSize: 15),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    S.of(context).reSend,
                                    style: const TextStyle(
                                        color: ColorManager.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30),
                            decoration: BoxDecoration(
                              color: ColorManager.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ButtonTheme(
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  bloc.add(VerifyCodeEvent(
                                    code: otpController.text,
                                  ));
                                },
                                child: Center(
                                    child: Text(
                                  S.of(context).verify.toUpperCase(),
                                  style: const TextStyle(
                                      color: ColorManager.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
