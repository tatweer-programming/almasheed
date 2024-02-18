import 'package:almasheed/authentication/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/error/remote_error.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/widgets/widgets.dart';
import '../../bloc/auth_bloc.dart';
import '../../data/models/address.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = AuthBloc.get(context);
    TextEditingController floorController = TextEditingController();
    TextEditingController apartmentController = TextEditingController();
    TextEditingController buildingController = TextEditingController();
    TextEditingController streetController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController avenueController = TextEditingController();
    TextEditingController plotController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Form(
      key: formKey,
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          return BlocConsumer<AuthBloc, AuthState>(
              bloc: bloc,
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100.w,
                        child: ClipPath(
                          clipper: HalfCircleCurve(18.h),
                          child: Container(
                            height: 35.h,
                            color: ColorManager.primary,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    S.of(context).addAddress,
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 3.h),
                                  Icon(
                                    Icons.maps_ugc_outlined,
                                    color: ColorManager.white,
                                    size: 40.sp,
                                  ),
                                  SizedBox(width: 3.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Padding(
                          padding: EdgeInsetsDirectional.only(start: 5.w, end: 5.w),
                          child: Column(
                            children: [
                              searchDropdownBuilder(
                                  text: S.of(context).addressType,
                                  onChanged: (value) {
                                    bloc.add(ChooseAddressTypeEvent(value!));
                                  },
                                  items: bloc.addressTypes(context),
                                  icon: Icons.home_outlined),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      searchDropdownBuilder(
                                        text: S.of(context).city,
                                        onChanged: (value) {
                                          bloc.add(ChooseCityEvent(value!));
                                        },
                                        items: ConstantsManager.getSaudiCities,
                                        icon: Icons.location_city_outlined,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      mainFormField(
                                        controller: plotController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterPlot;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.text,
                                        label: S.of(context).plot,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      mainFormField(
                                        controller: avenueController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterAvenue;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.text,
                                        label: S.of(context).avenue,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      mainFormField(
                                        controller: floorController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterFloor;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.number,
                                        label: S.of(context).floor,
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      mainFormField(
                                        controller: areaController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterArea;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.text,
                                        label: S.of(context).area,
                                        prefix: Icons.location_city,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      mainFormField(
                                        controller: streetController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterStreet;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.text,
                                        label: S.of(context).street,
                                        prefix: Icons.location_pin,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      mainFormField(
                                        controller: buildingController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterHouseNumber;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.number,
                                        label: S.of(context).houseNumber,
                                        prefix: Icons.home,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      mainFormField(
                                        controller: apartmentController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return S.of(context).enterApartmentNumber;
                                          }
                                          return null;
                                        },
                                        type: TextInputType.number,
                                        label: S.of(context).apartmentNumber,
                                        prefix: Icons.apartment_sharp,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              state is AddAddressLoadingState
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : defaultButton(
                                      text: S.of(context).addAddress,
                                      onPressed: () {
                                        if (formKey.currentState!.validate() &&
                                            bloc.addressType != null &&
                                            bloc.city != null) {
                                          bloc.add(AddAddressEvent(Address(
                                              street: streetController.text,
                                              city: bloc.city!,
                                              houseNumber: int.parse(buildingController.text),
                                              floor: int.parse(floorController.text),
                                              apartmentNumber: int.parse(apartmentController.text),
                                              area: areaController.text,
                                              plot: plotController.text,
                                              avenue: avenueController.text,
                                              type: bloc.addressType!)));
                                        }
                                      })
                            ],
                          )),
                    ],
                  ),
                );
              },
              listener: (context, state) {
                if (state is AddAddressSuccessfulState) {
                  defaultToast(msg: S.of(context).addedSuccessfully);
                  Navigator.pop(context);
                } else if (state is AddAddressErrorState) {
                  errorToast(msg: ExceptionManager(state.exception).translatedMessage());
                }
              });
        },
      ),
    ));
  }
}
