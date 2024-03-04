import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/images_manager.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/error/remote_error.dart';
import '../../../generated/l10n.dart';
import '../../data/models/customer.dart';
import '../../data/models/merchant.dart';

class MaintenanceLoginScreen extends StatelessWidget {
  const MaintenanceLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        bloc: bloc,
        listenWhen: (context, state) {
          return true;
        },
        listener: (context, state) {
          if (state is SendCodeErrorState) {
            errorToast(
                msg: ExceptionManager(state.exception).translatedMessage());
          } else if (state is CodeSent) {
            defaultToast(msg: S.of(context).codeSent);
            context.push(const OTPScreen());
          } else if (state is UserNotFoundState) {
            errorToast(msg: S.of(context).userNotFound);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: bloc,
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                bloc.add(MakeSelectedAccountTypeNullEvent());
                return true;
              },
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AuthBackground(
                        imagePath: ImagesManager.building_3,
                        child: Padding(
                          padding: EdgeInsets.all(15.0.sp),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(S.of(context).welcome,
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeightManager.bold,
                                    color: ColorManager.white,
                                  )),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(S.of(context).signInNow,
                                  style: TextStyle(
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
                                      value: bloc.isWorker,
                                      onChanged: (value) {
                                        bloc.add(ChangeIsWorkerTypeEvent(
                                            state: value!));
                                      }),
                                  Text(
                                    S.of(context).loginAsWorker,
                                    style: const TextStyle(
                                        color: ColorManager.white),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              bloc.timeToResendCode != null &&
                                      bloc.timeToResendCode! > 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${S.of(context).resendCodeIn} ",
                                          style: const TextStyle(
                                            color: ColorManager.white,
                                          ),
                                        ),
                                        BlocBuilder<AuthBloc, AuthState>(
                                          bloc: bloc,
                                          builder: (context, state) {
                                            return Text(
                                              "${bloc.timeToResendCode} ",
                                              style: const TextStyle(
                                                color: ColorManager.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          S.of(context).seconds,
                                          style: const TextStyle(
                                            color: ColorManager.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      // margin: EdgeInsets.symmetric(
                                      //   horizontal: 16.0.sp,
                                      // ),
                                      decoration: BoxDecoration(
                                        color: ColorManager.white,
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                      ),
                                      child: ButtonTheme(
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (bloc.isWorker) {
                                                Worker worker = Worker(
                                                    commercialLicenseNumber:
                                                        "",
                                                    name: "",
                                                    city: "",
                                                    location: "",
                                                    works: [],
                                                    id: "",
                                                    phone:
                                                        "+966${phoneController.text}",
                                                    facility: '');
                                                bloc.add(LoginByPhoneEvent(
                                                    worker));
                                              } else {
                                                Customer customer = Customer(
                                                    name: "",
                                                    addresses: [],
                                                    cartItems: {},
                                                    favorites: [],
                                                    orders: [],
                                                    id: "",
                                                    phone:
                                                        "+966${phoneController.text}");
                                                bloc.add(LoginByPhoneEvent(
                                                    customer));
                                              }
                                            }
                                          },
                                          child: Center(
                                              child: state
                                                      is SendCodeLoadingState
                                                  ? const CircularProgressIndicator()
                                                  : Text(
                                                      S
                                                          .of(context)
                                                          .sendCode,
                                                      style: const TextStyle(
                                                          color:
                                                              ColorManager
                                                                  .primary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    )),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 10.sp,
                                ),
                                child: const RegisterNowWidget(
                                  type: "maintenance",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ConstantsManager.registrationSkipped =
                                      true;
                                  context.pushAndRemove(const MainScreen());
                                },
                                child: Container(
                                  padding: EdgeInsetsDirectional.all(5.sp),
                                  decoration: BoxDecoration(
                                    color: ColorManager.black,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.sp)),
                                  ),
                                  child: Text(
                                    S.of(context).skipRegistration,
                                    style: const TextStyle(
                                        color: ColorManager.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
