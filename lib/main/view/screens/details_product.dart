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
import '../../../generated/l10n.dart';
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
    final PaymentBloc paymentBloc = PaymentBloc.get();
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
                        _buildAddToCart(
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
                              mainErrorToast(
                                  msg: S.of(context).determineQuantity);
                            }
                          },
                          context: context,
                        ),
                        SizedBox(height: 3.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Center(
                            child: Text(
                              product.productDescription.isEmpty
                                  ? S.of(context).notFound
                                  : product.productDescription,
                              style:
                                  const TextStyle(color: ColorManager.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
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
      mainErrorToast(msg: ExceptionManager(state.error).translatedMessage());
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
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Column(
                children: [
                  Container(
                    color: ColorManager.white,
                    child: defaultCarousel(
                      height: 45.h,
                      bloc: bloc,
                      list: product.productsImagesUrl ?? [],
                      controller: carouselController,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
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
                          PopupMenuItem<String>(
                            value: 'Edit',
                            child: Text(S.of(context).edit),
                          ),
                          PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text(S.of(context).delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
          Card(
            elevation: 7.sp,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.sp),
              borderSide: BorderSide.none,
            ),
            child: Container(
              width: 80.w,
              // height: 30.h,
              decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadiusDirectional.circular(20.sp)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.sp),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "${S.of(context).price} ${product.productOldPrice} ${S.of(context).sar}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: const Color(0xff496591),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "${S.of(context).seller} : ${product.merchantName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    if (isCustomer)
                      Row(
                        children: [
                          Expanded(
                            child: iconContainer(
                              color: ColorManager.white,
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
                              icon: customer!.favorites
                                      .contains(product.productId)
                                  ? Icons.favorite_sharp
                                  : Icons.favorite_border,
                            ),
                          ),
                          Expanded(
                            child: iconContainer(
                              color: ColorManager.white,
                              padding: 5.sp,
                              size: 20.sp,
                              onPressed: () {},
                              icon: Icons.share_outlined,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCart(
      {required BuildContext context,
      required VoidCallback onPressed,
      required TextEditingController quantityController}) {
    final isNotMerchant = ConstantsManager.appUser is! Merchant;
    return isNotMerchant
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: S.of(context).quantity,
                        hintStyle: TextStyle(
                          fontSize: 8.sp,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        )),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: defaultButton(
                    onPressed: onPressed,
                    text: S.of(context).addToCart,
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
          content: Text(
            S.of(context).productAdded,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
