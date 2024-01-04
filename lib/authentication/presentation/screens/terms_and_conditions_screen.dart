import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final String userType;

  const TermsAndConditionsScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    String termsAndConditions = userType == "customer"
        ?  S.of(context).termsToCustomer : S.of(context).termsToMerchant;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).termsAndConditions),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: SingleChildScrollView(
          child: Center(
            child:
                SelectableText(textAlign: TextAlign.center, termsAndConditions),
          ),
        ),
      ),
    );
  }
}
