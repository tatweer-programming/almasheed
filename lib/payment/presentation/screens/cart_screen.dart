import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/localization_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer customer = ConstantsManager.appUser as Customer;
    MainBloc mainBloc = sl();

    print(customer.cartItems.toString() + "(((((((((((((((((((((((((((((");

    PaymentBloc bloc = PaymentBloc.get(context);
    return Scaffold(
        body: BlocBuilder<PaymentBloc, PaymentState>(
      bloc: bloc,
      builder: (context, state) {
        List<Product> items = mainBloc.products
            .where(
                (element) => customer.cartItems.containsKey(element.productId))
            .toList();
        return items.isEmpty
            ? Center(child: Text(S.of(context).noItems))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: ClipPath(
                              clipper: HalfCircleCurve(12.h),
                              child: Container(
                                height: 35.h,
                                color: ColorManager.primary,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 8.w, end: 8.w, top: 1.h),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        S.of(context).cart,
                                        style: TextStyle(
                                            color: ColorManager.white,
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 3.h),
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: ColorManager.white,
                                        size: 40.sp,
                                      ),
                                      SizedBox(width: 1.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => CartItem(
                                    bloc: bloc,
                                    product: items[index],
                                    quantity: customer.cartItems[
                                            items[index].productId] ??
                                        1,
                                    quantityController:
                                        TextEditingController(text: ""),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 5.sp,
                                  ),
                                  itemCount: items.length,
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w),
                    child: Container(
                      height: 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(10.sp),
                          bottomEnd: Radius.circular(10.sp),
                        ),
                        color: ColorManager.primary,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${S.of(context).totalPrice}: ",
                              style: TextStyle(
                                  color: ColorManager.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "${bloc.getTotalPrice()} ",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: ColorManager.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    S.of(context).sar,
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            FittedBox(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: ColorManager.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                ),
                                child: Text(
                                  S.of(context).payDeposit,
                                  style: const TextStyle(
                                      color: ColorManager.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
      },
    ));
  }
}
