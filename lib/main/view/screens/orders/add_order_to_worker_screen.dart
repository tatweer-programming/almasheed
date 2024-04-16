import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/main/view/screens/maps/google_maps_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../generated/l10n.dart';

class AddOrderToWorkerScreen extends StatelessWidget {
  const AddOrderToWorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController cityController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController orderDetailsController = TextEditingController();
    MainBloc bloc = sl();
    String? work;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetNameOfLocationState) {
          locationController.text = state.location;
        }
        if (state is SelectWorkState) {
          work = state.work;
        }
        if (state is SetOrderForWorkersLoadingState) {
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
        if (state is SetOrderForWorkersErrorState) {
          context.pop();
          mainErrorToast(
              msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is SetOrderForWorkersSuccessfullyState) {
          bloc.add(MakeImagesFilesEmptyEvent());
          context.pop();
          context.pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp)),
                content: Text(
                  S.of(context).orderAdded,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  appBarWidget(S.of(context).addOrder, Icons.add_box_rounded),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                    child: Column(
                      children: [
                        searchDropdownBuilder(
                          text: S.of(context).work,
                          onChanged: (work) {
                            bloc.add(SelectWorkEvent(selectedWork: work!));
                          },
                          items: ConstantsManager.getWorks
                              .map((e) => e.label)
                              .toList(),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        mainFormField(
                          controller: cityController,
                          label: S.of(context).city,
                          border: true,
                          prefix: const Icon(
                            Icons.location_city,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S.of(context).enterCity;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        InkWell(
                          onTap: () {
                            context.push(const GoogleMapsScreen());
                          },
                          child: mainFormField(
                            controller: locationController,
                            label: S.of(context).location,
                            enabled: false,
                            maxLines: 2,
                            border: true,
                            prefix: const Icon(
                              Icons.location_pin,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).enterLocation;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        TextFormField(
                          controller: orderDetailsController,
                          minLines: 8,
                          maxLines: 25,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S.of(context).enterDetailsYourOrder;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            label: Text(S.of(context).detailsYourOrder),
                          ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        defaultButton(
                            onPressed: () {
                              if (work != null &&
                                  formKey.currentState!.validate()) {
                                bloc.add(
                                  SetOrderForWorkersEvent(
                                    orderForWorkers: OrderForWorkers(
                                      work: work!,
                                      customerId: ConstantsManager.userId!,
                                      customerName:
                                          (ConstantsManager.appUser as Customer)
                                              .name,
                                      accepted: false,
                                      workersIds: const [],
                                      city: cityController.text,
                                      location: locationController.text,
                                      orderDetails: orderDetailsController.text,
                                      latitude: bloc.latLng!.latitude,
                                      longitude: bloc.latLng!.longitude,
                                    ),
                                  ),
                                );
                              }
                            },
                            text: S.of(context).add)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
