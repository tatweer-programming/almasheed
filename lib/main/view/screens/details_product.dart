import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/services/dep_injection.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'modify_screen.dart';

class DetailsProductScreen extends StatelessWidget {
  final Product product;

  const DetailsProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CarouselController carouselController = CarouselController();
    TextEditingController quantityController = TextEditingController();
    final MainBloc mainBloc = sl();
    quantityController.text = "1";
    final PaymentBloc paymentBloc = PaymentBloc();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) => _handleBlocState(context, mainBloc, state),
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
                        _buildCarouselAndHeader(
                            context, mainBloc, carouselController),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: _buildProductDetailsTabs(context, product),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildFooter(
                  quantityController: quantityController,
                  onPressed: () {
                    if (quantityController.text != "") {
                      paymentBloc.add(
                        AddToCartEvent(
                          productId: product.productId,
                          quantity: int.parse(quantityController.text),
                        ),
                      );
                    } else {
                      errorToast(msg: "You must determine quantity");
                    }
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleBlocState(BuildContext context, MainBloc bloc, MainState state) {
    if (state is SelectEditProductState) {
      context.push(ModifyProductScreen(product: product));
    } else if (state is SelectDeleteProductState) {
      bloc.add(DeleteProductEvent(product: product));
    } else if (state is DeleteProductErrorState) {
      context.pop();
      errorToast(msg: ExceptionManager(state.error).translatedMessage());
    } else if (state is DeleteProductLoadingState) {
      _showDeleteProductLoadingDialog(context);
    } else if (state is DeleteProductSuccessfullyState) {
      _handleDeleteProductSuccess(context);
    }
  }

  Widget _buildCarouselAndHeader(BuildContext context, MainBloc bloc,
      CarouselController carouselController) {
    bool isCustomer = ConstantsManager.appUser is Customer;
    Customer? customer;
    if (isCustomer) {
      customer = ConstantsManager.appUser as Customer;
    }
    return Padding(
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
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: defaultCarousel(
                  height: 45.h,
                  list: product.productsImagesUrl ?? [],
                  controller: carouselController,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: iconContainer(
                  size: 25.sp,
                  padding: 5.sp,
                  onPressed: () => context.pop(),
                  icon: Icons.arrow_back_ios_new,
                ),
              ),
              if (!isCustomer)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorManager.primary,
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
                              selected: value,
                            ),
                          );
                        },
                        itemBuilder: (BuildContext context) =>
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
            ],
          ),
          if (isCustomer)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: iconContainer(
                padding: 5.sp,
                size: 20.sp,
                onPressed: () {
                  bloc.add(
                    AddAndRemoveFromFavoritesEvent(
                      favorites: customer!.favorites,
                      productId: product.productId,
                    ),
                  );
                },
                icon: customer!.favorites.contains(product.productId)
                    ? Icons.favorite_sharp
                    : Icons.favorite_border,
                color: ColorManager.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsTabs(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.sp),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Price ${product.productNewPrice.toStringAsFixed(2)} SAR",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: const Color(0xff496591),
              ),
            ),
            if (product.productNewPrice != product.productOldPrice)
              Text(
                "${product.productOldPrice.toStringAsFixed(2)} SAR",
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.red,
                    fontSize: 13.sp),
              ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Seller : ${product.merchantName}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
            ),
            Text(
              "City : ${product.productCity}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const TabBar(
          indicatorColor: ColorManager.primary,
          unselectedLabelColor: ColorManager.grey2,
          labelColor: ColorManager.primary,
          tabs: <Widget>[
            Tab(child: Text("Description")),
            Tab(child: Text("Evaluation")),
          ],
        ),
        SizedBox(
          height: 30.h,
          child: TabBarView(
            children: [
              _buildDescriptionTab(product.productDescription),
              _buildEvaluationTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTab(String productDescription) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text(
          productDescription.isEmpty ? "Not Found" : productDescription,
          style: const TextStyle(color: ColorManager.grey2),
        ),
      ),
    );
  }

  Widget _buildEvaluationTab() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text(
          "Not Found",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildFooter(
      {required VoidCallback onPressed,
      required TextEditingController quantityController}) {
    final isNotMerchant = ConstantsManager.appUser is! Merchant;
    return isNotMerchant
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                defaultFormField(
                    controller: quantityController,
                    width: 30.w,
                    textAlign: TextAlign.center,
                    type: TextInputType.number,
                    label: "Quantity"),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: defaultButton(
                    onPressed: onPressed,
                    text: "Add To Cart",
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  void _showDeleteProductLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.sp)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  void _handleDeleteProductSuccess(BuildContext context) {
    context.pop();
    context.pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5.sp)),
          content: const Text(
            "The product has been deleted successfully",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
