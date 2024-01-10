import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/widgets/widgets.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final String userType;

  const TermsAndConditionsScreen({
    super.key,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    String termsAndConditions;
    if (userType == "customer") {
      termsAndConditions = S.of(context).termsToCustomer;
    } else {
      termsAndConditions = S.of(context).termsToMerchant;
    }
    return Scaffold(
      body: SingleChildScrollView(
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
                    padding: EdgeInsetsDirectional.only(
                        start: 8.w, end: 8.w, top: 1.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          S.of(context).termsAndConditions,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 3.h),
                        Icon(
                          Icons.privacy_tip_outlined,
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
              height: 1.h,
            ),
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: SingleChildScrollView(
                child: Center(
                  child: SelectableText(
                      textAlign: TextAlign.center, termsAndConditions),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
