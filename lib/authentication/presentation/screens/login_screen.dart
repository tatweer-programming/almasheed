import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/images_manager.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/view/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../../generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  final bool isWorker;
  final bool isMerchant;

  const LoginScreen(
      {super.key, required this.isWorker, required this.isMerchant});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);
    MainBloc mainBloc = sl();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        bloc: bloc,
        listenWhen: (context, state) {
          return true;
        },
        listener: (context, state) {
          if (state is SendCodeErrorState) {
            // print(state.exception);
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
            return Form(
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
                            // Row(
                            //   children: [
                            //     Checkbox(
                            //         activeColor: ColorManager.white,
                            //         checkColor: ColorManager.black,
                            //         focusColor: ColorManager.white,
                            //         value: bloc.isWorker,
                            //         onChanged: (value) {
                            //           bloc.add(ChangeIsWorkerTypeEvent(
                            //               state: value!));
                            //         }),
                            //     Text(
                            //       S.of(context).loginAsWorker,
                            //       style: const TextStyle(
                            //           color: ColorManager.white),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            bloc.timeToResendCode != null &&
                                    bloc.timeToResendCode! > 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            if (isWorker) {
                                              Worker worker = Worker(
                                                  commercialLicenseNumber: "",
                                                  name: "",
                                                  city: "",
                                                  latitude: 24.774265,
                                                  location: "",
                                                  longitude: 46.738586,
                                                  works: [],
                                                  id: "",
                                                  brief: "",
                                                  ordersIds: <String>[],
                                                  phone:
                                                      "+966${phoneController.text}",
                                                  facility: '');
                                              bloc.add(
                                                  LoginByPhoneEvent(worker));
                                            } else if (isMerchant) {
                                              Merchant merchant = Merchant(
                                                companyName: "",
                                                city: "",
                                                area: "",
                                                registrationNumber: "",
                                                orders: [],
                                                id: "",
                                                phone:
                                                    "+966${phoneController.text}",
                                                productsIds: [],
                                              );
                                              bloc.add(
                                                  LoginByPhoneEvent(merchant));
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
                                              bloc.add(
                                                  LoginByPhoneEvent(customer));
                                            }
                                          }
                                        },
                                        child: Center(
                                            child: state is SendCodeLoadingState
                                                ? const CircularProgressIndicator()
                                                : Text(
                                                    S.of(context).sendCode,
                                                    style: const TextStyle(
                                                        color: ColorManager
                                                            .primary,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                              child: RegisterNowWidget(
                                type: "maintenance",
                                bloc: bloc,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                ConstantsManager.registrationSkipped = true;
                                mainBloc.add(GetProductsEvent());
                                context.pushAndRemove(const MainScreen());
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.all(5.sp),
                                decoration: BoxDecoration(
                                  color: ColorManager.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.sp)),
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
            );
          },
        ),
      ),
    );
  }
}
