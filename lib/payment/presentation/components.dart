import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../generated/l10n.dart';
//ignore: must_be_immutable
class CartItem extends StatefulWidget {
  Product product;
  int quantity;
  PaymentBloc bloc;
  TextEditingController quantityController;
  bool isQuantityEditingEnabled = false;

  CartItem({
    super.key,
    required this.bloc,
    required this.product,
    required this.quantity,
    required this.quantityController,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.sp,
        ),
      ),
      child: Card(
        elevation: 5,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide.none,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 30.w,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorManager.grey1,
                    borderRadius: BorderRadius.circular(
                      10.sp,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            NetworkImage(widget.product.productsImagesUrl![0])),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.merchantName,
                        style: TextStyle(
                            fontWeight: FontWeightManager.bold,
                            fontSize: 17.sp),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.product.productNewPrice.toString(),
                            style: TextStyle(
                                fontSize: 15.sp, color: ColorManager.grey2),
                          ),
                          Text(
                            S.of(context).sar,
                            style: TextStyle(
                                fontSize: 15.sp, color: ColorManager.grey2),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 50.w,
                              child: widget.isQuantityEditingEnabled
                                  ? TextField(
                                      decoration: const InputDecoration(),
                                      keyboardType: TextInputType.number,
                                      onEditingComplete: () {
                                        _editingCompleted();
                                      },
                                      onSubmitted: (value) {
                                        _editingCompleted();
                                      },
                                      enabled: widget.isQuantityEditingEnabled,
                                      controller: widget.quantityController)
                                  : Center(
                                      child: Text(
                                        widget.quantity.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeightManager.bold,
                                            fontSize: 15.sp),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          if (!widget.isQuantityEditingEnabled)
                            widget.bloc.state is RemoveFromCartLoadingState
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    onPressed: () {
                                      widget.bloc.add(RemoveFromCart(
                                          productId: widget.product.productId));
                                      setState(() {
                                        widget.isQuantityEditingEnabled = true;
                                      });
                                    },
                                    icon: const Icon(Icons.edit))
                        ],
                      )
                    ],
                  ),
                )),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                  onPressed: () {
                    widget.bloc.add(
                        RemoveFromCart(productId: widget.product.productId));
                  },
                  icon: Icon(
                    Icons.remove_shopping_cart,
                    color: ColorManager.error,
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _editingCompleted() {
    setState(() {
      widget.isQuantityEditingEnabled = false;
      widget.quantity = int.parse(widget.quantityController.text);
      widget.bloc.add(EditQuantityInCart(
          productId: widget.product.productId, quantity: widget.quantity));
    });
  }
}
