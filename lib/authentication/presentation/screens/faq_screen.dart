import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          S.of(context).faq,
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
                      style: const TextStyle(fontWeight: FontWeightManager.bold),
                      textAlign: TextAlign.center,
                      S.of(context).faqText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
