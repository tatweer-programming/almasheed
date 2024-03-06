import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import '../../../authentication/data/models/customer.dart';
import '../../../authentication/data/models/merchant.dart';
import '../../../authentication/data/models/worker.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../generated/l10n.dart';
import '../../bloc/main_bloc.dart';

mainFormField(
        {String? label,
        Icon? prefix,
        String? hint,
        IconButton? suffix,
        bool? enabled = true,
        Color? fillColor,
        String? validatorText,
        TextInputType? type,
        bool border = true,
        void Function()? suffixFunction,
        FormFieldValidator? validator,
        bool obscureText = false,
        double? width,
        TextStyle? labelStyle,
        int? maxLines,
        int? minLines,
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
        maxLines: maxLines,
        minLines: minLines,
        style: const TextStyle(color: ColorManager.black),
        decoration: InputDecoration(
            prefixIcon: prefix,
            disabledBorder: OutlineInputBorder(
              borderSide: !border ? BorderSide.none : const BorderSide(),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            contentPadding:
                EdgeInsetsDirectional.symmetric(horizontal: 2.w, vertical: 1.h),
            focusedBorder: OutlineInputBorder(
              borderSide: !border ? BorderSide.none : const BorderSide(),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: !border ? BorderSide.none : const BorderSide(),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            errorStyle: TextStyle(color: ColorManager.error),
            fillColor: fillColor ?? ColorManager.white,
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
    menuHeight: 40.h,
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
    menuHeight: 40.h,
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

Widget textContainerWidget({required String text, Widget? widget}) => Container(
    width: double.infinity,
    height: 6.h,
    decoration: BoxDecoration(
        color: ColorManager.secondary,
        borderRadius: BorderRadiusDirectional.circular(10.sp)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Row(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          widget ?? const SizedBox()
        ],
      ),
    ));

Widget merchantAndWorkerWidget(
        {required String name,
        required String details,
        required VoidCallback onTap}) =>
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
                            name,
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
                            details,
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

Widget appBarWidget(String title, IconData icon) {
  return Align(
    alignment: AlignmentDirectional.topCenter,
    heightFactor: 0.12.h,
    child: ClipPath(
      clipper: HalfCircleCurve(14.h),
      child: Container(
        height: 32.h,
        width: double.infinity,
        color: ColorManager.primary,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
          child: Column(
            children: [
              SizedBox(
                height: 4.h,
              ),
              Text(
                title,
                style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3.h),
              Icon(
                icon,
                color: ColorManager.white,
                size: 40.sp,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Widget workerWidget({required Worker worker, required VoidCallback onTap}) =>
//     InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.sp),
//             borderSide: BorderSide.none),
//         elevation: 4.sp,
//         child: Container(
//             width: double.infinity,
//             height: 6.h,
//             decoration: BoxDecoration(
//                 color: ColorManager.white,
//                 gradient:
//                     const LinearGradient(begin: Alignment.topCenter, colors: [
//                   Color(0xffd7b58e),
//                   Color(0xffca9d68),
//                   Color(0xffca9d68),
//                   Color(0xffbc8443),
//                 ]),
//                 borderRadius: BorderRadiusDirectional.circular(10.sp)),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         const Icon(Icons.drive_file_rename_outline),
//                         SizedBox(
//                           width: 2.w,
//                         ),
//                         Expanded(
//                           child: Text(
//                             worker.name,
//                             style: TextStyle(
//                                 fontSize: 14.sp, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         const Icon(Icons.location_city),
//                         SizedBox(
//                           width: 2.w,
//                         ),
//                         Expanded(
//                           child: Text(
//                             worker.works.first,
//                             style: TextStyle(
//                                 fontSize: 14.sp, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Icon(Icons.arrow_forward_ios_sharp),
//                 ],
//               ),
//             )),
//       ),
//     );

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
                  height: 18.h,
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
                      Row(
                        children: [
                          Text(
                            "${product.productNewPrice} ${S.of(context).sar}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12.sp),
                          ),
                          const Spacer(),
                          if (product.productNewPrice !=
                              product.productOldPrice)
                            Text(
                              "${product.productOldPrice.toStringAsFixed(2)}  ${S.of(context).sar}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager.red,
                                  fontSize: 10.sp),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      ConstantsManager.appUser is Customer
                          ? Column(
                              children: [
                                defaultButton(
                                    onPressed: addCardPressed,
                                    height: 4.h,
                                    text: S.of(context).addToCart),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              ],
                            )
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

Widget categoryProductsVerticalWidget({
  required BuildContext context,
  required Product product,
  required VoidCallback addCardPressed,
  required VoidCallback openProductPressed,
  required TextEditingController controller,
}) {
  if (controller.text == "") controller.text = "1";
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
                  height: 18.h,
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
                      Row(
                        children: [
                          Text(
                            "${product.productNewPrice} ${S.of(context).sar}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12.sp),
                          ),
                          const Spacer(),
                          if (product.productNewPrice !=
                              product.productOldPrice)
                            Text(
                              "${product.productOldPrice.toStringAsFixed(2)} ${S.of(context).sar}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager.red,
                                  fontSize: 10.sp),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      ConstantsManager.appUser is Customer
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: defaultButton(
                                          onPressed: addCardPressed,
                                          height: 4.h,
                                          text: S.of(context).addToCart,
                                          fontSize: 11.sp),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                      height: 4.h,
                                      child: mainFormField(
                                          controller: controller,
                                          type: TextInputType.number),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                              ],
                            )
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

Widget categoryVerticalWidget({
  required Category category,
  required VoidCallback categoryPressed,
}) {
  return InkWell(
    onTap: categoryPressed,
    child: Card(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: BorderSide.none),
      elevation: 4.sp,
      child: Container(
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
                image: category.categoryImage != null &&
                        category.categoryImage!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(category.categoryImage!),
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
                    category.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget favouriteProduct(
    {required Product product,
    required VoidCallback addCardPressed,
    required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
    child: Container(
      height: 26.h,
      width: double.infinity,
      color: ColorManager.grey1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  S.of(context).mainUses,
                  style:
                      TextStyle(fontSize: 13.sp, color: ColorManager.primary),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2.sp),
                    child: Text(
                      product.productMainUses,
                      maxLines: 7,
                      style:
                          TextStyle(fontSize: 11.sp, color: ColorManager.black),
                    ),
                  ),
                ),
                RatingBar.builder(
                  initialRating:
                      (product.productRating / product.ratingNumbers),
                  minRating: 1,
                  itemSize: 20.sp,
                  direction: Axis.horizontal,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0.5.w),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(
                  height: 2.h,
                )
              ],
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 15.h,
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
                        height: 0.2.h,
                      ),
                      Text(
                        product.productName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12.sp),
                      ),
                      SizedBox(
                        height: 0.2.h,
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
  if (propertyNameList.length == 1 && propertyNameList.first.text == "") {
    return {};
  }
  for (int i = 0; i < propertyNameList.length; i++) {
    String propertyName = propertyNameList[i].text;
    List<String> properties =
        propertyList[i].map((controller) => controller.text).toList();
    result[propertyName] = properties;
  }
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
    Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: ColorManager.grey2,
        child: Container(
          width: double.infinity,
          height: height ?? 5.h,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: ColorManager.primary,
            borderRadius: BorderRadiusDirectional.circular(10.sp),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 12.sp,
                  color: ColorManager.white),
            ),
          ),
        ),
      ),
    );

Widget iconContainer({
  required VoidCallback onPressed,
  required IconData icon,
  double? size,
  Color? color,
}) =>
    Container(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.5.w),
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
