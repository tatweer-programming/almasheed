import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/assets_manager.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/remote_error.dart';
import '../../../core/utils/font_manager.dart';
import '../../../generated/l10n.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController phoneController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);

    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      listenWhen: (context, state) {
        return state is CodeSent;
      },
      listener: (context, state) {
        if (state is SendCodeErrorState) {
          errorToast(
              msg: ExceptionManager(state.exception).translatedMessage());
        } else if (state is CodeSent) {
          defaultToast(msg: S.of(context).codeSent);
          context.push(const OTPScreen());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Expanded(
                    child: AuthBackground(
                      imagePath: AssetsManager.building_2,
                      child: Padding(
                        padding: EdgeInsets.all(5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(S.of(context).welcomeToAlmasheed,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeightManager.bold,
                                  color: ColorManager.white,
                                )),
                            SizedBox(
                              height: 4.sp,
                            ),
                            Text(S.of(context).createYourAccountNow,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  //fontWeight: FontWeightManager.bold,
                                  color: ColorManager.white,
                                )),
                            SizedBox(
                              height: 2.8.h,
                            ),
                            PhoneNumberInput(controller: phoneController),
                            SizedBox(
                              height: 10.sp,
                            ),
                            state is SendCodeLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Container(
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                    ),
                                    width: 90.w,
                                    height: 40.sp,
                                    child: InkWell(
                                      onTap: () {
                                        if (formKey.currentState!.validate() &&
                                            bloc.agreeToTerms) {
                                          Customer customer = Customer(
                                              addresses: [],
                                              cartItems: {},
                                              favorites: [],
                                              orders: [],
                                              id: "",
                                              phone:
                                                  "+966${phoneController.text}");
                                          bloc.add(SendCodeEvent(customer));
                                        } else if (!bloc.agreeToTerms) {
                                          errorToast(
                                              msg: S
                                                  .of(context)
                                                  .mustAgreeToTerms);
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          S.of(context).sendCode,
                                          style: const TextStyle(
                                              color: ColorManager.primary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            TermsAgreementWidget(
                                bloc: bloc, userType: "customer")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
