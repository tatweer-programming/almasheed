import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: bloc,
      listenWhen: (AuthState, authState) {
        return (bloc.state is Authenticated);
      },
      listener: (context, state) {
        if (bloc.state is Authenticated) {
          context.push(const MainScreen());
        }
      },
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          bloc: bloc,
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(10.w),
                child: ListView(
                  children: [
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Phone Number Verification',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8),
                      child: RichText(
                        text: TextSpan(
                            text: "Enter the code sent to ",
                            children: [
                              TextSpan(
                                  text: bloc.user?.phone,
                                  style: TextStyle(
                                      color: ColorManager.grey2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                            style: TextStyle(
                                color: ColorManager.black, fontSize: 15)),
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
                                return "you should enter all SMS code";
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
                          "Didn't receive the code? ",
                          style: TextStyle(
                              color: ColorManager.black, fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "RESEND",
                              style: TextStyle(
                                  color: ColorManager.primary,
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
                            "VERIFY".toUpperCase(),
                            style: TextStyle(
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
            );
          },
        );
      },
    );
  }
}
