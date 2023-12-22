import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/authentication/presentation/screens/terms_and_conditions_screen.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController phoneController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: bloc,
      listenWhen: (uthState, authState) {
        return (bloc.verificationId != null);
      },
      listener: (context, state) {
        if (bloc.verificationId != null) {
          context.push(const OTPScreen());
        }
      },
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          bloc: bloc,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: EdgeInsets.all(5.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Phone Number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      PhoneNumberInput(controller: phoneController),
                      SizedBox(
                        height: 10.sp,
                      ),
                      state is SendCodeLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.primary,
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(10, 20))),
                              width: 25.w,
                              height: 30.sp,
                              child: InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate() &&
                                      bloc.agreeToTerms) {
                                    Customer customer = Customer(
                                        cartItems: {},
                                        favorites: [],
                                        orders: [],
                                        id: "",
                                        phone: "+966${phoneController.text}");
                                    bloc.add(SendCodeEvent(customer));
                                  } else if (!bloc.agreeToTerms) {
                                    errorToast(
                                        msg:
                                            "You must agree to the terms and conditions");
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    " Send code ",
                                    style: TextStyle(color: ColorManager.white),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: bloc.agreeToTerms,
                              onChanged: (value) {
                                bloc.add(ChangeAgreeToTermsStateEvent(
                                    state: value!));
                              }),
                          Text(
                            "I Agree to",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          TextButton(
                              onPressed: () {
                                context.push(TermsAndConditionsScreen(
                                    userType: "customer"));
                              },
                              child: Text(
                                "Terms & conditions",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  decoration: TextDecoration.underline,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
