import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBarWidget(title:S.of(context).faq,icon:  Icons.privacy_tip_outlined,context:context),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: SingleChildScrollView(
                child: Center(
                  child: SelectableText(
                      style:
                          const TextStyle(fontWeight: FontWeightManager.bold),
                      textAlign: TextAlign.start,
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
