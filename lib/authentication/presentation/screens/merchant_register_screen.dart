import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/images_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../../core/utils/font_manager.dart';

import '../../bloc/auth_bloc.dart';
import '../components.dart';

class MerchantLoginScreen extends StatelessWidget {
  const MerchantLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController phoneController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController registrationNumberController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SendCodeErrorState) {
          errorToast(msg: ExceptionManager(state.exception).translatedMessage());
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    AuthBackground(
                        imagePath: ImagesManager.building_1,
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                  textAlign: TextAlign.center,
                                  S.of(context).welcomeToAlmasheed,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeightManager.bold,
                                    color: ColorManager.white,
                                  )),
                              SizedBox(
                                height: 4.sp,
                              ),
                              Text(
                                  textAlign: TextAlign.center,
                                  S.of(context).createYourAccountNow,
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
                                height: 7.5.sp,
                              ),
                              defaultFormField(
                                label: S.of(context).companyName,
                                controller: companyNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).enterCompanyName;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 7.5.sp,
                              ),
                              defaultFormField(
                                label: S.of(context).city,
                                controller: cityController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).enterCity;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 7.5.sp,
                              ),
                              defaultFormField(
                                label: S.of(context).area,
                                controller: areaController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).enterArea;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 7.5.sp,
                              ),
                              defaultFormField(
                                label: S.of(context).registrationNumber,
                                controller: registrationNumberController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).enterRegistration;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 7.5.sp,
                              ),
                              bloc.timeToResendCode != null && bloc.timeToResendCode! > 0
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
                                  : state is SendCodeLoadingState
                                      ? const Center(child: CircularProgressIndicator())
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: ColorManager.white,
                                            borderRadius: BorderRadius.circular(10.sp),
                                          ),
                                          width: 90.w,
                                          height: 40.sp,
                                          child: InkWell(
                                            onTap: () {
                                              if (formKey.currentState!.validate() &&
                                                  bloc.agreeToTerms == true) {
                                                Merchant merchant = Merchant(
                                                    productsIds: [],
                                                    companyName: companyNameController.text,
                                                    city: cityController.text,
                                                    area: areaController.text,
                                                    registrationNumber:
                                                        registrationNumberController.text,
                                                    orders: [],
                                                    id: "",
                                                    phone: "+966${phoneController.text}");
                                                bloc.add(SendCodeEvent(merchant));
                                              } else if (!bloc.agreeToTerms) {
                                                errorToast(msg: S.of(context).mustAgreeToTerms);
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
                                height: 7.5.sp,
                              ),
                              TermsAgreementWidget(bloc: bloc, userType: "merchant")
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
