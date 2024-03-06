import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/generated/l10n.dart';
import 'package:almasheed/main/view/screens/maps/google_maps_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:sizer/sizer.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/localization_manager.dart';
import '../../../main/bloc/main_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../data/models/worker.dart';
import '../components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
    Worker worker = (ConstantsManager.appUser as Worker);
    phoneController.text = worker.phone;
    cityController.text = worker.city;
    locationController.text = worker.location;
    facilityController.text = worker.facility;
    nameController.text = worker.name;
    briefController.text = worker.brief;
    commercialLicenseNumberController.text = worker.commercialLicenseNumber;
    List<ValueItem> works = [];
    for (var element in worker.works) {
      if (LocalizationManager.getCurrentLocale().languageCode == "ar") {
        works.add(ConstantsManager.convertWorkToArabic(
            ValueItem(label: element, value: element)));
      } else {
        works.add(ConstantsManager.convertWorkToEnglish(
            ValueItem(label: element, value: element)));
      }
    }
    AuthBloc bloc = AuthBloc.get(context);
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetNameOfLocationState) {
          locationController.text = state.location;
        }
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdateWorkerLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.sp)),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    ));
              },
            );
          }
          if (state is UpdateWorkerErrorState) {
            context.pop();
            mainErrorToast(
                msg: ExceptionManager(state.exception).translatedMessage());
          }
          if (state is UpdateWorkerSuccessfulState) {
            context.pop();
            context.pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp)),
                  content: Text(
                    S.of(context).editSuccess,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            );
          }
        },
        bloc: bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          PhoneNumberInput(controller: phoneController),
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
                          ),
                          SizedBox(
                            height: 7.5.sp,
                          ),
                          mainFormField(
                            label: S.of(context).brief,
                            maxLines: 5,
                            minLines: 3,
                            controller: briefController,
                            fillColor: ColorManager.secondary,
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
                            selectedOptions: works,
                            fieldBackgroundColor: ColorManager.secondary,
                            optionsBackgroundColor: ColorManager.secondary,
                            onOptionSelected: (options) {
                              List<String> selectedValues = options
                                  .map((item) => item.value)
                                  .where((value) => value != null)
                                  .cast<
                                      String>() // Cast to non-nullable string
                                  .toList();
                              bloc.add(ChooseWorkEvent(selectedValues));
                            },
                            options: ConstantsManager.getWorks,
                            maxItems: ConstantsManager.getWorks.length,
                            selectionType: SelectionType.multi,
                            chipConfig:
                                const ChipConfig(wrapType: WrapType.wrap),
                            dropdownHeight: 200,
                            optionTextStyle: const TextStyle(fontSize: 16),
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
                            label: S.of(context).commercialLicenseNumber,
                            controller: commercialLicenseNumberController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).enterCommercialLicense;
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
                          defaultButton(
                            onPressed: () {
                              bloc.add(UpdateWorkerEvent(Worker(
                                  name: nameController.text,
                                  city: cityController.text,
                                  brief: briefController.text,
                                  latitude: worker.latitude,
                                  longitude: worker.longitude,
                                  location: locationController.text,
                                  facility: facilityController.text,
                                  commercialLicenseNumber:
                                      commercialLicenseNumberController.text,
                                  id: ConstantsManager.userId!,
                                  works: bloc.works,
                                  phone: phoneController.text)));
                            },
                            text: S.of(context).edit,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
