import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import '../../../../authentication/presentation/components.dart';
import '../../../../generated/l10n.dart';
import 'modify_screen.dart';

//ignore: must_be_immutable
class DetailsProductScreen extends StatelessWidget {
  Product product;
  final List<Product> products;

  DetailsProductScreen(
      {super.key, required this.product, required this.products});

  @override
  Widget build(BuildContext context) {
    final PaymentBloc paymentBloc = PaymentBloc.get();
    final CarouselController carouselController = CarouselController();
    TextEditingController quantityController = TextEditingController();
    final MainBloc mainBloc = sl();
    mainBloc.lastSeenProducts.add(product);
    List<String> selectedProperties = [];
    quantityController.text = "1";
    return BlocListener<PaymentBloc, PaymentState>(
      bloc: paymentBloc,
      listener: _handlePaymentBlocState,
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if (state is SelectEditProductState) {
            context.push(ModifyProductScreen(product: product));
          } else if (state is SelectDeleteProductState) {
            mainBloc.add(DeleteProductEvent(product: product));
          } else if (state is DeleteProductErrorState) {
            context.pop();
            mainErrorToast(
                msg: ExceptionManager(state.error).translatedMessage());
          } else if (state is DeleteProductLoadingState) {
            _showDeleteProductLoadingDialog(context);
          } else if (state is DeleteProductSuccessfullyState) {
            _handleDeleteProductSuccess(context);
          } else if (state is SelectPropertiesState) {
            selectedProperties = state.selectedProperties;
          }
          if (state is CheckIfAvailablePropertiesState) {
            selectedProperties = state.availableProperties;
          }
          if (state is ProductRatingUpdateSuccessfullyState) {
            product.productRating = state.rating;
            product.ratingNumbers = state.numbers;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCarouselAndHeader(
                            context: context,
                            selectedProperties: selectedProperties,
                            bloc: mainBloc,
                            carouselController: carouselController),
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
                        textDescription(
                            title: S.of(context).overview,
                            context: context,
                            body: product.productOverview),
                        textDescription(
                            title: S.of(context).mainUses,
                            context: context,
                            body: product.productMainUses),
                        textDescription(
                            title: S.of(context).WorkCharacteristics,
                            context: context,
                            body: product.productWorkCharacteristics),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          child:
                              textContainerWidget(text:S.of(context).youMayLikeIt,),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 2.h),
                            child: SizedBox(
                              height: 31.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                separatorBuilder: (context, index) => SizedBox(
                                  width: 1.w,
                                ),
                                itemBuilder: (context, index) =>
                                    productVerticalWidget(
                                  openProductPressed: () {
                                    context.push(DetailsProductScreen(
                                      product: products[index],
                                      products: products,
                                    ));
                                  },
                                  product: products[index],
                                  addCardPressed: () {
                                    PaymentBloc paymentBloc = PaymentBloc.bloc;
                                    paymentBloc.add(
                                      AddToCartEvent(
                                        productId: products[index].productId,
                                      ),
                                    );
                                  },
                                  context: context,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handlePaymentBlocState(BuildContext context, PaymentState state) {
    if (state is AddToCartSuccessState) {
      defaultToast(msg: S.of(context).productAdded);
    } else if (state is AddToCartErrorState) {
      mainErrorToast(
          msg: ExceptionManager(state.exception).translatedMessage());
    }
  }

  Widget _buildCarouselAndHeader(
      {required BuildContext context,
      required MainBloc bloc,
      required List<String> selectedProperties,
      required CarouselController carouselController}) {
    bool isCustomer = ConstantsManager.appUser is Customer;
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 5.h),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
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
                    height: product.customProperties!.properties.isNotEmpty
                        ? 90
                        : 10.h,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: iconContainer(
                  size: 22.sp,
                  onPressed: () => context.pop(),
                  icon: Icons.arrow_back_ios_new,
                ),
              ),
              if (!isCustomer)
                Align(
                  alignment: AlignmentDirectional.topEnd,
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
                    Row(
                      children: [
                        Text(
                          "${S.of(context).price} ${product.productNewPrice} ${S.of(context).sar}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: const Color(0xff496591),
                          ),
                        ),
                        Spacer(),
                        if (product.productNewPrice != product.productOldPrice)
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
                              size: 20.sp,
                              onPressed: () {
                                bloc.add(
                                  AddAndRemoveFromFavoritesEvent(
                                    favorites:
                                        (ConstantsManager.appUser as Customer)
                                            .favorites,
                                    productId: product.productId,
                                  ),
                                );
                              },
                              icon: (ConstantsManager.appUser as Customer)
                                      .favorites
                                      .contains(product.productId)
                                  ? Icons.favorite_sharp
                                  : Icons.favorite_border,
                            ),
                          ),
                          Expanded(
                            child: iconContainer(
                              color: ColorManager.white,
                              size: 20.sp,
                              onPressed: () {},
                              icon: Icons.share_outlined,
                            ),
                          ),
                        ],
                      ),
                    if (product.customProperties!.properties.isNotEmpty)
                      SizedBox(
                        height: 16.h,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount:
                                product.customProperties!.properties.length,
                            itemBuilder: (BuildContext context, int index) {
                              String key = product
                                  .customProperties!.properties.keys
                                  .elementAt(index);
                              List<String> properties =
                                  product.customProperties!.properties[key]!;
                              return ListTile(
                                title: Text(
                                  key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: properties
                                      .map((prop) => InkWell(
                                            onTap: () {
                                              bloc.add(SelectPropertiesEvent(
                                                  prop: prop,
                                                  properties: properties,
                                                  selectedProperties:
                                                      selectedProperties));
                                              bloc.add(
                                                  CheckIfAvailablePropertiesEvent(
                                                      product: product,
                                                      selectedProperties:
                                                          selectedProperties));
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsetsDirectional
                                                      .symmetric(
                                                          horizontal: 2.w,
                                                          vertical: 1.h),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: selectedProperties
                                                                .contains(prop)
                                                            ? ColorManager
                                                                .primary
                                                            : Colors
                                                                .transparent),
                                                    color:
                                                        ColorManager.secondary,
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(10.sp),
                                                  ),
                                                  child: Text(
                                                    prop,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              );
                            }),
                      ),
                    RatingBar.builder(
                      initialRating:
                          (product.productRating / product.ratingNumbers),
                      minRating: 1,
                      itemSize: 25.sp,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.5.w),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        bloc.add(ProductRatingUpdateEvent(
                            productRating: (product.productRating + rating),
                            productId: product.productId));
                      },
                    )
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
                  height: 5.h,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: quantityController,
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
            S.of(context).productDeleted,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}

Widget textDescription(
    {required String title,
    required String body,
    required BuildContext context}) {
  return Center(
    child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
                color: ColorManager.secondary,
                borderRadius: BorderRadiusDirectional.circular(20.sp)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              child: Text(title),
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Text(
            title.isEmpty ? S.of(context).notFound : body,
            style: const TextStyle(color: ColorManager.primary),
          ),
        ),
      ],
    ),
  );
}
