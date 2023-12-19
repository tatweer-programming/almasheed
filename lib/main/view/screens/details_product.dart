import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/screens/modify_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';

class DetailsProductScreen extends StatelessWidget {
  final Product product;
  const DetailsProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    MainBloc bloc = sl();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc.add(GetCategoriesEvent());
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 5.h),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        color: ColorManager.grey1,
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                      ),
                                      child: defaultCarousel(
                                          height: 45.h,
                                          list: product.productsImagesUrl ?? [],
                                          controller: carouselController)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 1.h),
                                    child: iconContainer(
                                        size: 25.sp,
                                        vertical: 1.h,
                                        horizontal: 1.w,
                                        onPressed: () {
                                          context.pop();
                                        },
                                        icon: Icons.arrow_back_ios_new),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      child: iconContainer(
                                          horizontal: 3.w,
                                          size: 20.sp,
                                          onPressed: () {
                                            context.push(ModifyProductScreen(
                                              product: product,
                                            ));
                                          },
                                          icon: Icons.edit),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  child: iconContainer(
                                      horizontal: 3.w,
                                      size: 20.sp,
                                      onPressed: () {},
                                      icon: Icons.favorite_border),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Price ${product.productOldPrice} SAR",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: const Color(0xff496591))),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text("Seller : ${product.merchantName}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp,
                                      color: Colors.grey[600])),
                              TabBar(
                                indicatorColor: ColorManager.primary,
                                unselectedLabelColor: Colors.grey[600],
                                labelColor: ColorManager.primary,
                                tabs: const <Widget>[
                                  Tab(
                                    child: Text(
                                      "Description",
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "Evaluation",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.h,
                                child: TabBarView(
                                  children: [
                                    Center(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Text(
                                          product.productDescription == ""
                                              ? "Not Found"
                                              : product.productDescription,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Text(
                                          "Not Found",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child:
                        defaultButton(onPressed: () {}, text: "Add To Cart")),
                SizedBox(
                  height: 2.h,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
