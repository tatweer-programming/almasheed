import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/details_product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';

List<String> list = [
  "https://static.independent.co.uk/s3fs-public/thumbnails/image/2015/10/19/11/attack-on-titan.jpg",
  "https://www.cnet.com/a/img/resize/597f8167c5bc132e301df0e4052180b26b5e4c7d/hub/2022/01/07/18439ff0-d202-4d93-b233-3e203a7617fd/aot-f2-pv02-00-01-11-06-still075.jpg?auto=webp&fit=crop&height=675&width=1200",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK_dpI9V5LsmeCAWth-VVt4LCJ4-uQq7Tr6w&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhZHbbrSxPuCzOdrugXgNjG5tS3Cp1J3uE1i2qBcsPcuPi7LtvzeVXrTwBPvqiNX7vkEg&usqp=CAU",
];
List<String> list2 = ["Ahmed","Mohamed","Mahmoud","Ahmed","Mohamed","Mahmoud","Ahmed","Mohamed","Mahmoud","Ahmed","Mohamed","Mahmoud","ALI"];

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    MainBloc bloc = sl();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc.add(GetOffersEvent());
          bloc.add(GetCategoriesEvent());
          bloc.add(GetBestSalesEvent());
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 16.h,
              decoration: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.sp),
                    bottomRight: Radius.circular(20.sp),
                  )),
              child: Padding(
                padding:
                    EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 7.h,
                        child: searchDropdownBuilder(
                            value: bloc.selectedProduct,
                            text: "search ...",
                            onChanged: (product) {
                              bloc.add(SelectProductEvent(product: product!));
                              context.push(DetailsProductScreen(product: product));
                            },
                            items: bloc.products, context: context
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: ColorManager.white,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    defaultCarousel(list: list, controller: carouselController),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          bloc.categories.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textContainerWidget("Categories"),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(
                                      height: 14.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            categoryWidget(
                                                category:
                                                    bloc.categories[index]),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 5.w,
                                        ),
                                        itemCount: bloc.categories.length,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          bloc.offers.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textContainerWidget("Hot Deals"),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(
                                      height: 32.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            productWidget(
                                                openProductPressed: () {
                                                  context.push(DetailsProductScreen(product: bloc.offers[index]));
                                                },
                                                product: bloc.offers[index],
                                                addCardPressed: () {}),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 4.w,
                                        ),
                                        itemCount: bloc.offers.length,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          bloc.bestSales.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textContainerWidget("Best Sales"),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(
                                      height: 32.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            productWidget(
                                                openProductPressed: () {
                                                  context.push(DetailsProductScreen(product: bloc.bestSales[index]));
                                                },
                                                product: bloc.bestSales[index],
                                                addCardPressed: () {}),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 8.w,
                                        ),
                                        itemCount: bloc.bestSales.length,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(height: 1.h,),
                          textContainerWidget("Sellers"),
                          SizedBox(height: 1.h,),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => sellerWidget(name: list2[index],),
                              separatorBuilder:
                              (context, index) => SizedBox(height: 1.h,), itemCount: list2.length)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
