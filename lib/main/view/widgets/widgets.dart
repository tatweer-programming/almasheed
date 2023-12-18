import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../authentication/data/models/merchant.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../bloc/main_bloc.dart';

// defaultFormField(
//     {String? label,
//       IconData? prefix,
//       String? hint,
//       IconButton? suffix,
//       bool? enabled = true,
//       String? validatorText,
//       TextInputType? type,
//       void Function()? suffixFunction,
//       FormFieldValidator? validator,
//       bool obscureText = false,
//       required TextEditingController controller}) =>
//     TextFormField(
//       onTapOutside: (event) {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       controller: controller,
//       keyboardType: type,
//       enabled: enabled,
//       cursorColor: ColorManager.primary,
//       obscureText: obscureText,
//       style: TextStyle(color: ColorManager.black),
//       decoration: InputDecoration(
//           disabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: ColorManager.secondary),
//             borderRadius: BorderRadius.circular(10.sp),
//           ),
//           contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.sp),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.sp),
//           ),
//           errorStyle: const TextStyle(fontSize: 0.01),
//           fillColor: ColorManager.white,
//           suffixIcon: suffix,
//           labelText: label,
//           helperText: hint,
//           labelStyle: TextStyle(
//             color: ColorManager.black,
//           )),
//       validator: validator,
//     );

Widget searchProductDropdownBuilder(
    {required Product? value,
    required String text,required BuildContext context,
    required Function(Product? value) onChanged,
    required List<Product> items}) {
  return DropdownSearch<Product>(
    itemAsString: (Product p) => p.productName,
    popupProps: PopupProps.menu(
      showSearchBox: true,
      itemBuilder: (context, product, isSelected) {
        return searchWidget(product: product, isSelected: isSelected);
      },
    ),
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
          filled: true,
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
          contentPadding: EdgeInsetsDirectional.all(5.sp),
          fillColor: ColorManager.white,
          prefixIcon: const Icon(Icons.search),
          hintText: text,
          hintStyle: TextStyle(
            fontSize: 10.sp,
          )),
    ),
    items: items,
    onChanged: onChanged,
    selectedItem: value,
  );
}


Widget searchDropdownBuilder(
    {required String? value,
      required String text,
      IconData? icon,
      required Function(String? value) onChanged,
      required List<String> items}) {
  return DropdownSearch<String>(
      popupProps:
      const PopupProps.menu(showSelectedItems: true, showSearchBox: true),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            labelText: text,
            filled: true,
            enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
            focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
            prefixIcon: Icon(icon??Icons.search,),
            contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
            labelStyle: TextStyle(
              fontSize: 10.sp,
            )),
      ),
      items: items,
      onChanged: onChanged,
      selectedItem: value);
}

Widget searchWidget({required Product product,required bool isSelected}) =>
    Container(
      padding: EdgeInsetsDirectional.only(start: 3.w,top: 2.h,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(5.sp)),
            child: Image.network(
              product.productsImagesUrl.first,
              width: 15.w,
              height: 6.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 4.w,),
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

Widget defaultCarousel({
  required List<String> list,
  required CarouselController controller,
}) {
  MainBloc bloc = sl();
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      CarouselSlider(
        carouselController: controller,
        items: list
            .map((image) => Image(
                  image: NetworkImage(
                    image,
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ))
            .toList(),
        options: CarouselOptions(
          onPageChanged: (index, reason) {
            bloc.add(ChangeCarouselIndicatorEvent(index: index));
          },
          height: 22.h,
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
      child: Text(text,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    ));
Widget merchantsWidget({
  required Merchant merchant
}) => Card(
  shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.sp),
    borderSide: BorderSide.none
  ),
  elevation: 4.sp,
  child: Container(
      width: double.infinity,
      height: 6.h,
      decoration: BoxDecoration(
          color: ColorManager.white,
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xffe6ccb2),
                Color(0xffddb892),
                Color(0xffddb892),
                Color(0xffb08968),
              ]
          ),
          borderRadius: BorderRadiusDirectional.circular(10.sp)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.drive_file_rename_outline),
                  SizedBox(width: 2.w,),
                  Expanded(
                    child: Text(merchant.companyName,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),Expanded(
              child: Row(
                children: [
                  const Icon(Icons.location_city),
                  SizedBox(width: 2.w,),
                  Expanded(
                    child: Text(merchant.city,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_sharp),
          ],
        ),
      )),
);

Widget categoryWidget({required Category category,required VoidCallback onTap}) => InkWell(
  onTap: onTap,
  child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: ColorManager.grey1,
            backgroundImage: NetworkImage(category.categoryImage),
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
          borderSide: BorderSide.none
      ),
        elevation: 4.sp,
        child: Stack(
          children: [
            Container(
              height: 32.h,
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
                      image: product.productsImagesUrl.isNotEmpty ? DecorationImage(
                        image: NetworkImage(product.productsImagesUrl[0]),
                        fit: BoxFit.cover,
                      ) : null,
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
                          "${product.productPrice} SAR",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        defaultButton(
                            onPressed: addCardPressed,
                            height: 5.h,
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
})=>Container(
  clipBehavior: Clip.antiAliasWithSaveLayer,
  decoration: BoxDecoration(
    borderRadius: BorderRadiusDirectional.circular(5.sp),
  ),
  child: MaterialButton(
    onPressed: onPressed,
    minWidth: double.infinity,
    height: height??7.h,
    color: ColorManager.primary,
    child: Text(
      text,
      style: TextStyle(fontSize: 14.sp, color: ColorManager.white),
    ),
  ),
);


Widget iconContainer({
  required VoidCallback onPressed,
  required IconData icon,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Container(
        padding: EdgeInsetsDirectional.all(2.sp),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: ColorManager.secondary),
        child: IconButton(onPressed: onPressed, icon: Icon(icon)),
      ),
    );
