import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/images_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/generated/l10n.dart';
import 'package:almasheed/main/view/screens/maps/google_maps_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:sizer/sizer.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/font_manager.dart';

import '../../../main/bloc/main_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../data/models/worker.dart';
import '../components.dart';

class WorkerRegisterScreen extends StatelessWidget {
  const WorkerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController phoneController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController briefController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController facilityController = TextEditingController();
    TextEditingController commercialLicenseNumberController =
        TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);
    MainBloc mainBloc = sl();
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetNameOfLocationState) {
          locationController.text = state.location;
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
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
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: AuthBackground(
                      imagePath: ImagesManager.building_1,
                      child: Padding(
                        padding: EdgeInsets.all(5.w),
                        child: Column(
                          children: [
                            Column(
                              children: [
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
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    PhoneNumberInput(
                                        controller: phoneController),
                                    SizedBox(
                                      height: 7.5.sp,
                                    ),
                                    defaultFormField(
                                      label: S.of(context).name,
                                      controller: nameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S.of(context).enterCompanyName;
                                        }
                                        return null;
                                      },
                                    ),SizedBox(
                                      height: 7.5.sp,
                                    ),
                                    mainFormField(
                                      label: S.of(context).brief,
                                      maxLines: 5,
                                      minLines: 3,
                                      fillColor: ColorManager.secondary,
                                      controller: briefController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S.of(context).enterBrief;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 7.5.sp,
                                    ),
                                    MultiSelectDropDown(
                                      borderColor: ColorManager.secondary,
                                      fieldBackgroundColor:
                                          ColorManager.secondary,
                                      optionsBackgroundColor:
                                          ColorManager.secondary,
                                      onOptionSelected: (options) {
                                        List<String> selectedValues = options
                                            .map((item) => item.value)
                                            .where((value) => value != null)
                                            .cast<
                                                String>() // Cast to non-nullable string
                                            .toList();
                                        bloc.add(
                                            ChooseWorkEvent(selectedValues));
                                      },
                                      options: ConstantsManager.getWorks,
                                      maxItems:
                                          ConstantsManager.getWorks.length,
                                      selectionType: SelectionType.multi,
                                      chipConfig: const ChipConfig(
                                          wrapType: WrapType.wrap),
                                      dropdownHeight: 200,
                                      optionTextStyle:
                                          const TextStyle(fontSize: 16),
                                      selectedOptionIcon:
                                          const Icon(Icons.check_circle),
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
                                    InkWell(
                                      onTap: () {
                                        context.push(const GoogleMapsScreen());
                                      },
                                      child: mainFormField(
                                        label: S.of(context).location,
                                        controller: locationController,
                                        fillColor: ColorManager.secondary,
                                        enabled: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterLocation;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.5.sp,
                                    ),
                                    defaultFormField(
                                      label:
                                          S.of(context).commercialLicenseNumber,
                                      controller:
                                          commercialLicenseNumberController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S
                                              .of(context)
                                              .enterCommercialLicense;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 7.5.sp,
                                    ),
                                    defaultFormField(
                                      label: S.of(context).facility,
                                      controller: facilityController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S.of(context).enterFacility;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 7.5.sp,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: ColorManager.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.sp),
                                                ),
                                                width: 90.w,
                                                height: 40.sp,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (mainBloc.latLng !=
                                                            null &&
                                                        formKey.currentState!
                                                            .validate() &&
                                                        bloc.agreeToTerms ==
                                                            true) {
                                                      Worker merchant = Worker(
                                                          city: cityController
                                                              .text,
                                                          ordersIds: <String>[],
                                                          longitude: mainBloc
                                                              .latLng!.longitude,
                                                          latitude: mainBloc
                                                              .latLng!.latitude,
                                                          location:
                                                              locationController
                                                                  .text,
                                                          id: "",
                                                          brief: briefController.text,
                                                          phone:
                                                              "+966${phoneController.text}",
                                                          name: nameController
                                                              .text,
                                                          facility:
                                                              facilityController
                                                                  .text,
                                                          commercialLicenseNumber:
                                                              commercialLicenseNumberController
                                                                  .text,
                                                          works: bloc.works);
                                                      bloc.add(SendCodeEvent(
                                                          merchant));
                                                    } else if (!bloc
                                                        .agreeToTerms) {
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
                                                          color: ColorManager
                                                              .primary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    SizedBox(
                                      height: 7.5.sp,
                                    ),
                                    TermsAgreementWidget(
                                        bloc: bloc, userType: "worker"),
                                  ],
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
