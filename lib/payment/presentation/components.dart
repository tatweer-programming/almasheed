import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/screens/details_product.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/data/models/orderItem.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../generated/l10n.dart';

//ignore: must_be_immutable
class CartItem extends StatefulWidget {
  OrderItem orderItem;
  PaymentBloc bloc;
  TextEditingController quantityController;
  bool isQuantityEditingEnabled = false;

  CartItem({
    super.key,
    required this.bloc,
    required this.orderItem,
    required this.quantityController,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 25.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10.sp,
            ),
          ),
          child: Container(
            height: 40.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(10.sp),
                bottomEnd: Radius.circular(10.sp),
              ),
              color: ColorManager.primary,
            ),
            child: Row(
              children: [
                Container(
                  height: 40.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    color: ColorManager.grey1,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            widget.orderItem.product.productsImagesUrl![0])),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),

                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      widget.orderItem.product.productName,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeightManager.bold,
                          fontSize: 17.sp),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "${S.of(context).price}: ",
                          style: TextStyle(
                              fontWeight: FontWeightManager.semiBold,
                              fontSize: 15.sp,
                              color: ColorManager.white),
                        ),
                        Text(
                          "${widget.orderItem.product.productNewPrice} ",
                          style: TextStyle(
                              fontWeight: FontWeightManager.bold,
                              fontSize: 15.sp,
                              color: ColorManager.secondary),
                        ),
                        Text(
                          S.of(context).sar,
                          style: TextStyle(
                              fontWeight: FontWeightManager.semiBold,
                              fontSize: 15.sp,
                              color: ColorManager.white),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${S.of(context).quantity}: ",
                          style: TextStyle(
                              fontWeight: FontWeightManager.semiBold,
                              fontSize: 15.sp,
                              color: ColorManager.white),
                        ),
                        if (!widget.isQuantityEditingEnabled)
                          Text(
                            "${widget.orderItem.quantity}",
                            style: TextStyle(
                                fontWeight: FontWeightManager.bold,
                                fontSize: 15.sp,
                                color: ColorManager.secondary),
                          ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        if (!widget.isQuantityEditingEnabled)
                          widget.bloc.state is RemoveFromCartLoadingState
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.isQuantityEditingEnabled = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: ColorManager.white,
                                  )),
                      ],
                    ),
                    if (widget.isQuantityEditingEnabled)
                      SizedBox(
                        width: 20.w,
                        child: defaultFormField(
                          label: S.of(context).quantity,
                          controller: widget.quantityController,
                          validator: (value) {
                            if (value!.isEmpty || value == "0") {
                              return S.of(context).enterValidQuantity;
                            }
                            return null;
                          },
                        ),
                      ),
                    if (!widget.isQuantityEditingEnabled)
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${S.of(context).totalPrice}: ",
                                  style: TextStyle(
                                      fontWeight: FontWeightManager.semiBold,
                                      fontSize: 15.sp,
                                      color: ColorManager.white),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "${widget.orderItem.quantity * widget.orderItem.product.productNewPrice} ",
                                    style: TextStyle(
                                        fontWeight: FontWeightManager.bold,
                                        fontSize: 15.sp,
                                        color: ColorManager.secondary),
                                  ),
                                ),
                                Text(
                                  S.of(context).sar,
                                  style: TextStyle(
                                      fontWeight: FontWeightManager.semiBold,
                                      fontSize: 15.sp,
                                      color: ColorManager.white),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: IconButton(
              onPressed: () {
                widget.bloc.add(RemoveFromCart(
                    productId: widget.orderItem.product.productId));
              },
              icon: Icon(
                Icons.remove_shopping_cart,
                color: ColorManager.error,
              )),
        )
      ],
    );
  }

  void _editingCompleted() {
    setState(() {
      widget.isQuantityEditingEnabled = false;
      widget.orderItem.quantity = int.parse(widget.quantityController.text);
      widget.bloc.add(EditQuantityInCart(
          productId: widget.orderItem.product.productId,
          quantity: widget.orderItem.quantity));
    });
  }
}

class OrderItemBuilder extends StatelessWidget {
  final OrderItem item;

  const OrderItemBuilder({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 10.h,
      child: InkWell(
        onTap: () {
          // context.push(Product(product: item.product));
        },
        child: Card(
          color: ColorManager.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Text(item.product.productName)),
                SizedBox(
                  width: 5.w,
                ),
                Text(item.quantity.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
