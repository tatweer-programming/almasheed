import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final String userType;

  const TermsAndConditionsScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    String termsAndConditions = userType == "customer"
        ? "- إن منصة المشيد مخصصة لتسهيل عملية الشراء والتواصل بين العميل وصاحب المنشأة، ولإتمام عملية الشراء تقوم المنصة بخصم مبلغ رمزي من قيمة الشراء كمحصّلة لنشاط المنصة وكعربون غير مسترد عند إتمام الطلب .\n- يحق للعميل التواصل مع صاحب المنشأة ( البائع ) للاستفسار وإتمام طلبات الشراء أو إلغاءها حسب الاتفاق بينهما ، علمًا بأن المنصة غير مسؤولة عن أي خلافات مالية أو غيرها تكون بين العميل وصاحب المنشأة.\n-إذا أراد العميل إلغاء الطلب قبل استلامه عليه التواصل مع صاحب المنشأة وإبلاغه بذلك، وفي حال وصول الطلب إلى العميل ثم أراد إلغاء الطلب فعندها يتحمل العميل تكلفة نقل المواد التي تم شراؤها من مقر استلامه إلى مقر صاحب المنشأة أو حسب مايتفقان عليه.\n- يحق للمنصة حذف أو إيقاف نشاط العميل المخالف لسياسة المنصة بأي وسيلةٍ كانت، بما في ذلك الطلبات الوهمية وعدم الجدية في الطلب ، كما يمكن للعميل التواصل مع صاحب المنشأة في حال وجود أي ملاحظات متعلقة بالطلب.\n- إن منصة المشيد تحتفظ بلائحة الشروط الموضحة وتمنع تداول أو نشر هذه اللائحة في أي وسيلة كانت.\n- وسائل التواصل المعتمدة داخل المنصة \nايميل : almasheed-1380@hotmail.com \n واتساب : 0537014738"
        : "- إن منصة المشيد مخصصة لتسهيل عملية الشراء والتواصل بين العميل وصاحب المنشأة بطريقة واضحة وبسيطة مع توفير الجهد والوقت على كلا الطرفين.\n-عند إتمام طلب الشراء من العميل تقوم المنصة بخصم رمزي لا يتجاوز 10٪ من قيمة الشراء كمحصلة لنشاط المنصة وكعربون غير مسترد عند إتمام الطلب .\n-يلتزم صاحب المنشأة بتوفير الطلب للعميل بشكل دقيق بما في ذلك الجودة وسلامة المواد وسرعة التوصيل حسب المتفق بينهما . \n-يكون هنالك مجال للتواصل بين العميل ومقدم الخدمة للاتفاق على تفاصيل الشراء كطلبات الشراء   وحساب التكلفة الإجمالية وطريقة التوصيل وغيرها مما يتعلق بطلبات الشراء.\n-يحق للعميل إلغاء الطلب قبل استلامه وذلك بالتواصل مع صاحب المنشأة ، وفي حال استلامه الطلب ورغبته في إلغاء الطلب يُلزم العميل بدفع تكلفة النقل من مكان استلامه إلى مقر صاحب المنشأة أو حسب المتفق بينهما .\n- إن منصة المشيد هدفها تسهيل التواصل بين الطرفين وأنها غير مسؤولة عن أي خلافات بين العميل وصاحب المنشأة بما في ذلك الخلافات المالية وغيرها على سبيل المثال لا الحصر: عدم الدقة في الطلب، والأخطاء الناجمة عن التوصيل كضرر يلحق بطلبات الشراء وغيرها.\n- يحق للمنصة حذف أو إيقاف نشاط المنشأة المخالفة لسياسة المنصة بأي وسيلةٍ كانت، كما يمكن لصاحب المنشأة التواصل مع فريق الدعم في حال تعرضه لأي مشكلة متعلقة بخدمات المنصة.\n- إن منصة المشيد تحتفظ بلائحة الشروط الموضحة وتمنع تداول أو نشر هذه اللائحة في أي وسيلة كانت.\n- وسائل التواصل المعتمدة داخل المنصة  \n ايميل : almasheed-1380@hotmail.com \n واتساب :  0537014738";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and conditions"),
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
