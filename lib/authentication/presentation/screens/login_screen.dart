// import 'package:almasheed/authentication/bloc/auth_bloc.dart';
// import 'package:almasheed/authentication/data/models/customer.dart';
// import 'package:almasheed/authentication/presentation/components.dart';
// import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
// import 'package:almasheed/core/utils/color_manager.dart';
// import 'package:almasheed/core/utils/navigation_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../data/models/merchant.dart';
//
// class LoginScreen  extends StatelessWidget {
//    const LoginScreen ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     GlobalKey<FormState> formKey = GlobalKey<FormState>();
//     TextEditingController phoneController = TextEditingController();
//     AuthBloc bloc = AuthBloc.get(context);
//
//     return BlocConsumer<AuthBloc, AuthState>(
//       bloc: bloc,
//       listenWhen: (uthState, authState) {
//         return (bloc.verificationId != null);
//       },
//       listener: (context, state) {
//         if (bloc.verificationId != null) {
//           context.push(const OTPScreen());
//         }
//       },
//       builder: (context, state) {
//         return BlocBuilder<AuthBloc, AuthState>(
//           bloc: bloc,
//           builder: (context, state) {
//             return Scaffold(
//               body: Center(
//                 child: Form(
//                   key: formKey,
//                   child: Padding(
//                     padding: EdgeInsets.all(10.w),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Welcome back to almasheed",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16.sp),
//                         ),
//                         SizedBox(
//                           height: 20.sp,
//                         ),
//                         Text(
//                           "Login now ",
//                           style: TextStyle(fontSize: 14.sp),
//                         ),
//                         SizedBox(
//                           height: 10.sp,
//                         ),
//                         PhoneNumberInput(controller: phoneController),
//                         SizedBox(
//                           height: 10.sp,
//                         ),
//                         Row(
//                           children: [
//                             Checkbox(value: bloc.isMerchant,
//                                 onChanged: (value) {
//                                   bloc.add(ChangeIsMerchantTypeStateEvent(state: value!));
//                                 }),
//                             const Text("Login as merchant")
//                           ],
//                         ) ,
//                         SizedBox(
//                           height: 10.sp,
//                         ),
//                         state is SendCodeLoadingState
//                             ? const Center(child: CircularProgressIndicator())
//                             : Container(
//                           decoration: const BoxDecoration(
//                               color: ColorManager.primary,
//                               borderRadius: BorderRadius.all(
//                                   Radius.elliptical(10, 20))),
//                           width: 25.w,
//                           height: 30.sp,
//                           child: InkWell(
//                             onTap: () {
//                               if (formKey.currentState!.validate() ) {
//                                 if (bloc.isMerchant){
//                                   Merchant customer = Merchant(
//                                     registrationNumber: "",
//                                       companyName: "",
//                                       city: "",
//                                       area: "",
//                                       productsIds: [],
//                                       orders: [],
//                                       id: "",
//                                       phone: "+966${phoneController.text}");
//                                   bloc.add(LoginByPhoneEvent(customer));
//                                 }
//                                 else {
//                                   Customer customer = Customer(
//                                       cartItems: {},
//                                       favorites: [],
//                                       orders: [],
//                                       id: "",
//                                       phone: "+966${phoneController.text}");
//                                   bloc.add(LoginByPhoneEvent(customer));
//                                 }
//                               }
//                             },
//                             child: const Center(
//                               child: Text(
//                                 " Send code ",
//                                 style: TextStyle(color: ColorManager.white),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(
//                           height: 20.sp,
//                         ),
//                         Padding(padding: EdgeInsets.only(
//                           bottom: 20.sp ,
//
//                         ) ,
//                         child: const RegisterNowWidget(),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/assets_manager.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';
import '../../data/models/customer.dart';
import '../../data/models/merchant.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    AuthBloc bloc = AuthBloc();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
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
          return Form(
            key: formKey,
            child: Column(

              children: [
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AuthBackground(imagePath: AssetsManager.building_3, child:  Padding(
                    padding: EdgeInsets.all(16.0.sp),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(S.of(context).welcome, style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeightManager.bold,
                          color: ColorManager.white,
                        )),
                        SizedBox(
                          height: 5.sp,
                        ),
                        Text(S.of(context).signInNow, style: TextStyle(
                          fontSize: 15.sp,
                          //fontWeight: FontWeightManager.bold,
                          color: ColorManager.white,
                        )),
                        SizedBox(
                          height: 4.h,
                        ),
                        PhoneNumberInput(controller: phoneController),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: ColorManager.white,
                                checkColor: ColorManager.black,
                                focusColor: ColorManager.white,
                                value: bloc.isMerchant,
                                onChanged: (value) {
                                  bloc.add(ChangeIsMerchantTypeStateEvent(state: value!));
                                }),
                             Text( S.of(context).loginAsMerchant , style: TextStyle(
                                color: ColorManager.white
                            ),)
                          ],
                        ) ,
                        SizedBox(
                          height: 10.sp,
                        ),
                        Container(
                          // margin: EdgeInsets.symmetric(
                          //   horizontal: 16.0.sp,
                          // ),
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: ButtonTheme(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
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
                              }
                              ,
                              child: Center(
                                  child: state is SendCodeLoadingState
                                      ? const CircularProgressIndicator(): Text(
                                    S.of(context).sendCode,
                                    style: const TextStyle(
                                        color: ColorManager.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
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
                  )),
                )
              ],
            ),
          );
        },
      );
  },
),);
  }
}
