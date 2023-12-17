import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/screens/details_product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../bloc/main_bloc.dart';

Widget searchDropdownBuilder(
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

Widget searchWidget({required Product product,required bool isSelected}) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(5.sp)),
            child: Image.network(
              product.productsImages.first,
              width: 20.w,
              height: 7.h,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            product.productName,
            style: TextStyle(
                color: isSelected ? ColorManager.primary : ColorManager.black,
                fontSize: 12.sp,
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
Widget sellerWidget({
  required String name,
  String? image,
}) => Card(
  shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.sp),
    borderSide: BorderSide.none
  ),
  elevation: 4.sp,
  child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadiusDirectional.circular(10.sp)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: image != null
                  ? NetworkImage(image) as ImageProvider<Object>?
                  : const AssetImage("assets/images/default_image.jpg",) as ImageProvider<Object>?,
            ),
            SizedBox(width: 2.w,),
            Expanded(
              child: Text(name,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      )),
);

Widget categoryWidget({required Category category}) => Column(
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
                      image: DecorationImage(
                        image: NetworkImage(product.productsImages[0]),
                        fit: BoxFit.cover,
                      ),
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
