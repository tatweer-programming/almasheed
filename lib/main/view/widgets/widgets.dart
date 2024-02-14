import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import '../../../authentication/data/models/customer.dart';
import '../../../authentication/data/models/merchant.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../generated/l10n.dart';
import '../../bloc/main_bloc.dart';

mainFormField(
        {String? label,
        IconData? prefix,
        String? hint,
        IconButton? suffix,
        bool? enabled = true,
        String? validatorText,
        TextInputType? type,
        void Function()? suffixFunction,
        FormFieldValidator? validator,
        bool obscureText = false,
        double? width,
        TextStyle? labelStyle,
        TextAlign? textAlign,
        required TextEditingController controller}) =>
    SizedBox(
      width: width ?? double.infinity,
      child: TextFormField(
        textAlign: textAlign ?? TextAlign.start,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: controller,
        keyboardType: type,
        enabled: enabled,
        obscureText: obscureText,
        style: const TextStyle(color: ColorManager.black),
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
            contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
            errorStyle: TextStyle(color: ColorManager.error),
            fillColor: ColorManager.white,
            filled: true,
            suffixIcon: suffix,
            labelText: label,
            helperText: hint,
            labelStyle: labelStyle ??
                const TextStyle(
                  color: ColorManager.black,
                )),
        validator: validator,
      ),
    );

Widget searchDropdownBuilder(
    {required String text,
    IconData? icon,
    required Function(String? value) onChanged,
    required List<String> items}) {
  return DropdownMenu<String>(
    label: Text(text),
    enableFilter: true,
    requestFocusOnTap: true,
    expandedInsets: EdgeInsets.zero,
    enableSearch: true,
    leadingIcon: Icon(icon ?? Icons.search),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
      contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
    ),
    onSelected: onChanged,
    menuHeight: 65.h,
    dropdownMenuEntries: items.map<DropdownMenuEntry<String>>(
      (String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      },
    ).toList(),
  );
}

Widget searchProductDropdownBuilder(
    {required String text,
    required BuildContext context,
    required Function(Product? value) onChanged,
    required List<Product> items}) {
  return DropdownMenu<Product>(
    enableFilter: true,
    requestFocusOnTap: true,
    expandedInsets: EdgeInsets.zero,
    leadingIcon: const Icon(Icons.search),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
      contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
    ),
    onSelected: onChanged,
    dropdownMenuEntries: items.map<DropdownMenuEntry<Product>>(
      (Product product) {
        return DropdownMenuEntry<Product>(
          value: product,
          label: product.productName,
          leadingIcon: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width: 15.w,
                height: 6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                    image: product.productsImagesUrl!.isNotEmpty
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              product.productsImagesUrl!.first,
                            ),
                          )
                        : null),
              ),
              SizedBox(
                height: 1.h,
              )
            ],
          ),
        );
      },
    ).toList(),
  );
}

Widget searchWidget({required Product product, required bool isSelected}) =>
    Container(
      padding: EdgeInsetsDirectional.only(
        start: 3.w,
        top: 2.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: 15.w,
            height: 6.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.sp),
                image: product.productsImagesUrl!.isNotEmpty
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          product.productsImagesUrl!.first,
                        ),
                      )
                    : null),
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            product.productName,
            style: TextStyle(
                color: isSelected ? ColorManager.primary : ColorManager.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );

Widget defaultCarousel(
    {required List<String> list,
    required CarouselController controller,
    required MainBloc bloc,
    double? height}) {
  return Column(
    children: [
      CarouselSlider(
        carouselController: controller,
        items: list
            .map((image) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorManager.grey1,
                      borderRadius: BorderRadius.circular(40.sp),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          image,
                        ),
                      )),
                ))
            .toList(),
        options: CarouselOptions(
          onPageChanged: (index, reason) {
            bloc.add(ChangeCarouselIndicatorEvent(index: index));
          },
          height: height ?? 22.h,
          autoPlay: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 2),
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayCurve: Curves.easeInOutCubicEmphasized,
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: true,
        ),
      ),
      indicator(
          controller: controller,
          list: list,
          current: bloc.carouselIndicatorIndex)
    ],
  );
}

Widget indicator(
        {required List<String> list,
        required CarouselController controller,
        required int current}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => controller.animateToPage(entry.key),
          child: Container(
            width: 3.w,
            height: 3.h,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current != entry.key
                    ? ColorManager.secondary
                    : ColorManager.primary),
          ),
        );
      }).toList(),
    );

Widget textContainerWidget(String text) => Container(
    width: double.infinity,
    height: 7.h,
    decoration: BoxDecoration(
        color: ColorManager.secondary,
        borderRadius: BorderRadiusDirectional.circular(10.sp)),
    child: Padding(
      padding: EdgeInsets.all(10.sp),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
    ));

Widget merchantWidget(
        {required Merchant merchant, required VoidCallback onTap}) =>
    InkWell(
      onTap: onTap,
      child: Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide.none),
        elevation: 4.sp,
        child: Container(
            width: double.infinity,
            height: 6.h,
            decoration: BoxDecoration(
                color: ColorManager.white,
                gradient:
                    const LinearGradient(begin: Alignment.topCenter, colors: [
                  Color(0xffd7b58e),
                  Color(0xffca9d68),
                  Color(0xffca9d68),
                  Color(0xffbc8443),
                ]),
                borderRadius: BorderRadiusDirectional.circular(10.sp)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.drive_file_rename_outline),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Text(
                            merchant.companyName,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.location_city),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Text(
                            merchant.city,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_sharp),
                ],
              ),
            )),
      ),
    );

Widget categoryWidget(
        {required Category category, required VoidCallback onTap}) =>
    InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: ColorManager.grey1,
            backgroundImage: NetworkImage(category.categoryImage!),
          ),
          Text(
            category.categoryName,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
          )
        ],
      ),
    );

Widget productVerticalWidget({
  required BuildContext context,
  required Product product,
  required VoidCallback addCardPressed,
  required VoidCallback openProductPressed,
}) {
  return InkWell(
    onTap: openProductPressed,
    child: Card(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: BorderSide.none),
      elevation: 4.sp,
      child: Stack(
        children: [
          Container(
            width: 44.w,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadiusDirectional.circular(5.sp)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: ColorManager.grey1,
                    image: product.productsImagesUrl != null &&
                            product.productsImagesUrl!.isNotEmpty
                        ? DecorationImage(
                            image:
                                NetworkImage(product.productsImagesUrl!.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Text(
                        product.productName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12.sp),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Text(
                        "${product.productOldPrice} ${S.of(context).sar}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12.sp),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      ConstantsManager.appUser is Customer
                          ? defaultButton(
                              onPressed: addCardPressed,
                              height: 4.h,
                              text: S.of(context).addToCart)
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
          ConstantsManager.appUser is Customer
              ? Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Icon(
                    (ConstantsManager.appUser as Customer)
                            .favorites
                            .contains(product.productId)
                        ? Icons.favorite_sharp
                        : Icons.favorite_border,
                    color: ColorManager.red,
                  ),
                )
              : const SizedBox()
        ],
      ),
    ),
  );
}

Widget favouriteProduct({required Product product,required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
    child: Container(
      height: 20.h,
      width: double.infinity,
      color: ColorManager.grey1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                S.of(context).mainUses,
                style: TextStyle(fontSize: 15.sp, color: ColorManager.primary),
              ),
              Text(
                product.productMainUses,
                style: TextStyle(fontSize: 12.sp, color: ColorManager.black),
              ),
            ],
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: ColorManager.grey1,
                image: product.productsImagesUrl != null &&
                        product.productsImagesUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.productsImagesUrl!.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget productHorizontalWidget({
  required Product product,
  required VoidCallback openProductPressed,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0.5.h),
    child: InkWell(
      onTap: openProductPressed,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadiusDirectional.circular(5.sp)),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          "${product.productNewPrice.toStringAsFixed(2)} SAR",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        if (product.productNewPrice != product.productOldPrice)
                          Text(
                            "${product.productOldPrice.toStringAsFixed(2)} SAR",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w500,
                                color: ColorManager.red,
                                fontSize: 10.sp),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 13.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: ColorManager.grey1,
                      image: product.productsImagesUrl != null &&
                              product.productsImagesUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(
                                product.productsImagesUrl!.first,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ConstantsManager.appUser is Customer
              ? Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Icon(
                    (ConstantsManager.appUser as Customer)
                            .favorites
                            .contains(product.productId)
                        ? Icons.favorite_sharp
                        : Icons.favorite_border,
                    color: ColorManager.red,
                  ),
                )
              : const SizedBox()
        ],
      ),
    ),
  );
}

Map<String, List<String>> convertToMap(
    List<List<TextEditingController>> propertyList,
    List<TextEditingController> propertyNameList) {
  Map<String, List<String>> result = {};
  for (int i = 0; i < propertyNameList.length; i++) {
    String propertyName = propertyNameList[i].text;
    List<String> properties =
        propertyList[i].map((controller) => controller.text).toList();
    result[propertyName] = properties;
  }
  print(result);
  return result;
}

List<String> transformList(List<List<String>> inputList) {
  List<String> result = [];

  for (List<String> innerList in inputList) {
    String transformedString = innerList.join("-");
    result.add(transformedString);
  }
  print("result");
  print(result);
  return result;
}

Widget defaultButton({
  required VoidCallback onPressed,
  required String text,
  double? height,
  double? fontSize,
}) =>
    Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10.sp),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: double.infinity,
        height: height ?? 5.h,
        color: ColorManager.primary,
        child: Text(
          text,
          style:
              TextStyle(fontSize: fontSize ?? 12.sp, color: ColorManager.white),
        ),
      ),
    );

Widget iconContainer({
  required VoidCallback onPressed,
  required IconData icon,
  double? padding,
  double? size,
  Color? color,
}) =>
    Container(
      padding: EdgeInsets.all(padding ?? 5.sp),
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: ColorManager.primary),
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          icon,
          color: color ?? ColorManager.white,
          size: size ?? 12.sp,
        ),
      ),
    );

void mainToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.green,
    textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void mainErrorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.error,
    textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

class HalfCircleCurve extends CustomClipper<Path> {
  final double height;

  HalfCircleCurve(this.height);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path
      ..lineTo(0, size.height - height)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - height)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

Widget settingItemBuilder({
  required String label,
  required IconData iconData,
  Widget? suffixWidget,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
        height: 7.h,
        width: 90.w,
        child: Card(
          elevation: 5,
          color: ColorManager.primary,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.sp),
            borderSide: BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: ColorManager.white,
                ),
                SizedBox(
                  width: 5.sp,
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                suffixWidget ??
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorManager.white,
                    ),
              ],
            ),
          ),
        )),
  );
}
