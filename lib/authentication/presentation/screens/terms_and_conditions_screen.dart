import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String termsAndConditions;
    if (ConstantsManager.appUser is Customer) {
      termsAndConditions = S.of(context).termsToCustomer;
    } else {
      termsAndConditions = S.of(context).termsToMerchant;
    }
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
