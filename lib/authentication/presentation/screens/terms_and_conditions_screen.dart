import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
            appBarWidget(
               title: S.of(context).termsAndConditions,icon: Icons.privacy_tip_outlined,context:context),
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Center(
                child: SelectableText(
                  textAlign: TextAlign.center,
                  termsAndConditions,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
