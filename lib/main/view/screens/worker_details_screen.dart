import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';

class WorkerDetailsScreen extends StatelessWidget {
  final Worker worker;

  const WorkerDetailsScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController facilityController = TextEditingController();
    TextEditingController commercialLicenseNumberController =
        TextEditingController();
    TextEditingController briefController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    phoneNumberController.text = worker.phone;
    cityController.text = worker.city;
    locationController.text = worker.location;
    facilityController.text = worker.facility;
    briefController.text = worker.brief;
    commercialLicenseNumberController.text = worker.commercialLicenseNumber;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBarWidget(S.of(context).worker, Icons.miscellaneous_services),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      worker.name,
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    height: 20.h,
                    child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) => Center(
                              child: Text(
                                worker.works[index],
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: ColorManager.grey2,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => SizedBox(
                              height: 1.h,
                            ),
                        itemCount: worker.works.length),
                  ),
                  Column(
                    children: [
                      mainFormField(
                        controller: briefController,
                        label: S.of(context).brief,
                        minLines: 2,
                        maxLines: 5,
                        prefix: const Icon(
                          Icons.phone,
                        ),
                        enabled: false,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: phoneNumberController,
                        label: S.of(context).phoneNumber,
                        prefix: const Icon(
                          Icons.phone,
                        ),
                        enabled: false,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: locationController,
                        label: S.of(context).location,
                        prefix: const Icon(
                          Icons.location_pin,
                        ),
                        enabled: false,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: commercialLicenseNumberController,
                        label: S.of(context).commercialLicenseNumber,
                        prefix: const Icon(
                          Icons.numbers,
                        ),
                        enabled: false,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: facilityController,
                        label: S.of(context).facility,
                        prefix: const Icon(
                          Icons.construction_outlined,
                        ),
                        enabled: false,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: cityController,
                        label: S.of(context).city,
                        prefix: const Icon(
                          Icons.location_city,
                        ),
                        enabled: false,
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      defaultButton(
                          onPressed: () {}, text: S.of(context).contactUs)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
