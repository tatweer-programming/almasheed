import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/generated/l10n.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/constance_manager.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer customer = ConstantsManager.appUser as Customer;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100.w,
              child: ClipPath(
                clipper: HalfCircleCurve(18.h),
                child: Container(
                  height: 35.h,
                  color: ColorManager.primary,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 8.w, end: 8.w, top: 1.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          S.of(context).addresses,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 3.h),
                        Icon(
                          Icons.map_outlined,
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
            customer.addresses.isEmpty
                ? Text(
                    S.of(context).noAddresses,
                    style: const TextStyle(
                        // color: ColorManager.white,
                        // fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        AddressBuilder(address: customer.addresses[index]),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 1.h,
                        ),
                    itemCount: customer.addresses.length),
          ],
        ),
      ),
    );
  }
}
