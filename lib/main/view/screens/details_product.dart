import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../authentication/data/models/merchant.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';
import 'modify_screen.dart';

class DetailsProductScreen extends StatelessWidget {
  final Product product;
  const DetailsProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    MainBloc bloc = sl();
    Customer customer = ConstantsManager.appUser as Customer;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is SelectEditProductState) {
          context.push(ModifyProductScreen(product: product));
        } else if (state is SelectDeleteProductState) {
          bloc.add(DeleteProductEvent(product: product));
        }
        if (state is DeleteProductErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is DeleteProductLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp)),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ));
            },
          );
        }
        if (state is DeleteProductSuccessfullyState) {
          context.pop();
          context.pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp)),
                content: const Text(
                  "The product has been deleted successfully",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
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
                                        padding: 5.sp,
                                        onPressed: () {
                                          context.pop();
                                        },
                                        icon: Icons.arrow_back_ios_new),
                                  ),
                                  ConstantsManager.appUser is Merchant
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 1.h),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  ColorManager.primary,
                                              child: PopupMenuButton<String>(
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                  color: ColorManager.white,
                                                ),
                                                onSelected: (String value) {
                                                  bloc.add(
                                                      SelectEditOrDeleteProductEvent(
                                                          context: context,
                                                          product: product,
                                                          selected: value));
                                                },
                                                itemBuilder: (
                                                  BuildContext context,
                                                ) =>
                                                    <PopupMenuEntry<String>>[
                                                  const PopupMenuItem<String>(
                                                    value: 'Edit',
                                                    child: Text("Edit"),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'Delete',
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              ConstantsManager.appUser is! Merchant
                                  ? Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
                                        child: iconContainer(
                                          padding: 5.sp,
                                          size: 20.sp,
                                          onPressed: () {
                                            bloc.add(
                                                AddAndRemoveFromFavoritesEvent(
                                                    favorites:
                                                        customer.favorites,
                                                    productId:
                                                        product.productId));
                                          },
                                          icon: customer.favorites
                                                  .contains(product.productId)
                                              ? Icons.favorite_sharp
                                              : Icons.favorite_border,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
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
                ConstantsManager.appUser is! Merchant
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: defaultButton(
                            onPressed: () {}, text: "Add To Cart"))
                    : const SizedBox(),
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
