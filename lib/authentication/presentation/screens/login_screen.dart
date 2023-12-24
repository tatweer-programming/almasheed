import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/merchant.dart';

class LoginScreen  extends StatelessWidget {
   const LoginScreen ({super.key});

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
              body: Center(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome back to almasheed",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Text(
                          "Login now ",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        PhoneNumberInput(controller: phoneController),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Row(
                          children: [
                            Checkbox(value: bloc.isMerchant,
                                onChanged: (value) {
                                  bloc.add(ChangeIsMerchantTypeStateEvent(state: value!));
                                }),
                            const Text("Login as merchant")
                          ],
                        ) ,
                        SizedBox(
                          height: 10.sp,
                        ),
                        state is SendCodeLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                          decoration: const BoxDecoration(
                              color: ColorManager.primary,
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(10, 20))),
                          width: 25.w,
                          height: 30.sp,
                          child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate() ) {
                                if (bloc.isMerchant){
                                  Merchant customer = Merchant(
                                    registrationNumber: "",
                                      companyName: "",
                                      city: "",
                                      area: "",
                                      productsIds: [],
                                      orders: [],
                                      id: "",
                                      phone: "+966${phoneController.text}");
                                  bloc.add(LoginByPhoneEvent(customer));
                                }
                                else {
                                  Customer customer = Customer(
                                      cartItems: {},
                                      favorites: [],
                                      orders: [],
                                      id: "",
                                      phone: "+966${phoneController.text}");
                                  bloc.add(LoginByPhoneEvent(customer));
                                }
                              }
                            },
                            child: const Center(
                              child: Text(
                                " Send code ",
                                style: TextStyle(color: ColorManager.white),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20.sp,
                        ),
                        Padding(padding: EdgeInsets.only(
                          bottom: 20.sp ,

                        ) ,
                        child: const RegisterNowWidget(),
                        )
                      ],
                    ),
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
