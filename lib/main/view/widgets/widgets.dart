import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../authentication/data/models/merchant.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../bloc/main_bloc.dart';

defaultFormField(
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
        required TextEditingController controller}) =>
    TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      keyboardType: type,
      enabled: enabled,
      obscureText: obscureText,
      style: TextStyle(color: ColorManager.black),
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
          labelStyle: TextStyle(
            color: ColorManager.black,
          )),
      validator: validator,
    );

Widget searchDropdownBuilder(
    {required String text,
    IconData? icon,
    required Function(String? value) onChanged,
    required List<String> items}) {
  return DropdownMenu<String>(
    enableFilter: true,
    requestFocusOnTap: true,
    expandedInsets: EdgeInsets.zero,
    leadingIcon: const Icon(Icons.search),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp)
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
    ),
    onSelected: onChanged,
    dropdownMenuEntries:
    items.map<DropdownMenuEntry<String>>(
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
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp)
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
    ),
    onSelected: onChanged,
    dropdownMenuEntries:
    items.map<DropdownMenuEntry<Product>>(
          (Product product) {
        return DropdownMenuEntry<Product>(
          value: product,
          label: product.productName,
          leadingIcon: Container(
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
    double? height}) {
  MainBloc bloc = sl();
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      CarouselSlider(
        carouselController: controller,
        items: list
            .map((image) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorManager.grey1,
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
                    ? ColorManager.white
                    : ColorManager.primary),
          ),
        );
      }).toList(),
    );

Widget textContainerWidget(String text) => Container(
    width: double.infinity,
    height: 6.h,
    decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadiusDirectional.circular(10.sp)),
    child: Padding(
      padding: EdgeInsets.all(10.sp),
      child: Text(
        text,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    ));

Widget merchantsWidget(
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

Widget productWidget({
  required Product product,
  required VoidCallback addCardPressed,
  required VoidCallback openProductPressed,
}) =>
    InkWell(
      onTap: openProductPressed,
      child: Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.sp),
            borderSide: BorderSide.none),
        elevation: 4.sp,
        child: Stack(
          children: [
            Container(
              height: 33.h,
              width: 42.w,
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
                              image: NetworkImage(
                                  product.productsImagesUrl!.first),
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
                          "${product.productOldPrice} SAR",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        defaultButton(
                            onPressed: addCardPressed,
                            height: 4.h,
                            text: "Add To Cart")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.sp),
              child: Icon(
                Icons.favorite_border,
                color: ColorManager.white,
              ),
            )
          ],
        ),
      ),
    );

Widget defaultButton({
  required VoidCallback onPressed,
  required String text,
  double? height,
  double? fontSize,
}) =>
    Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(5.sp),
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
}) =>
    Container(
      padding: EdgeInsets.all(padding??5.sp),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: ColorManager.primary),
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          icon,
          color: ColorManager.white,
          size: size ?? 12.sp,
        ),
      ),
    );

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.green,
    textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.error,
    textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}
