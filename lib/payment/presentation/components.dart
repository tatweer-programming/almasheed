import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/data/models/order_item.dart';
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
                topStart: Radius.circular(20.sp),
                bottomStart: Radius.circular(20.sp),
              ),
              color: ColorManager.primary,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.sp),
                    child: Column(
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
                          children: [
                            Text(
                              "${S.of(context).quantity}: ",
                              style: TextStyle(
                                  fontWeight: FontWeightManager.semiBold,
                                  fontSize: 15.sp,
                                  color: ColorManager.white),
                            ),
                            Container(
                              height: 4.h,
                              decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.sp))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _decreaseCounter();
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.remove,
                                          size: 20.sp,
                                          color: ColorManager.primary,
                                        ),
                                      )),
                                  Text(
                                    " ${widget.orderItem.quantity} ",
                                    style: TextStyle(
                                        fontWeight: FontWeightManager.bold,
                                        fontSize: 15.sp,
                                        color: ColorManager.primary),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _increaseCounter();
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 20.sp,
                                          color: ColorManager.primary,
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
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
                                          fontWeight:
                                              FontWeightManager.semiBold,
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
                                          fontWeight:
                                              FontWeightManager.semiBold,
                                          fontSize: 15.sp,
                                          color: ColorManager.white),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
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
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topEnd,
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

  void _increaseCounter() {
    setState(() {
      widget.orderItem.quantity = widget.orderItem.quantity + 1;
      widget.quantityController.text = widget.orderItem.quantity.toString();
      widget.bloc.add(EditQuantityInCart(
          productId: widget.orderItem.product.productId,
          quantity: widget.orderItem.quantity));
    });
  }

  void _decreaseCounter() {
    if (widget.orderItem.quantity != 1) {
      setState(() {
        widget.orderItem.quantity =
            int.parse(widget.quantityController.text) - 1;
        widget.quantityController.text = widget.orderItem.quantity.toString();
        widget.bloc.add(EditQuantityInCart(
            productId: widget.orderItem.product.productId,
            quantity: widget.orderItem.quantity));
      });
    }
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

class OrderBuilder extends StatelessWidget {
  final OrderModel order;

  const OrderBuilder({super.key, required this.order});

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
            child: Column(
              children: [
                Expanded(
                    child: Text(
                        "${DateTime.parse(order.id).year} - ${DateTime.parse(order.id).month} - ${DateTime.parse(order.id).day}")),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                    child: Text(
                        "${order.orderItems.length} ${S.of(context).products}")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderDetailsItem extends StatelessWidget {
  final String title;
  final String value;

  const OrderDetailsItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.sp),
      padding: EdgeInsets.all(5.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(
            color: ColorManager.primary,
            width: 2,
          )),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: TextStyle(
                color: ColorManager.primary,
                fontWeight: FontWeightManager.bold,
                fontSize: 13.sp),
          )),
          Text(
            value,
            style: TextStyle(
              color: ColorManager.primary,
              fontSize: 13.sp,
              fontWeight: FontWeightManager.bold,
            ),
          ),
        ],
      ),
    );
  }
}
