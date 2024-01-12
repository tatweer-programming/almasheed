import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:almasheed/payment/presentation/screens/complete_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer customer = ConstantsManager.appUser as Customer;

    print(customer.cartItems.toString() + "(((((((((((((((((((((((((((((");

    PaymentBloc bloc = PaymentBloc.get()..add(PrepareCart());
    return Scaffold(
        body: BlocBuilder<PaymentBloc, PaymentState>(
      bloc: bloc,
      builder: (context, state) {
        print(bloc.order.orderItems.length.toString() +
            "(((((((((((((((((((((((((((((");
        bloc.add(PrepareCart());
        return Column(
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
                    bloc.order.orderItems.isEmpty
                        ? Center(child: Text(S.of(context).noItems))
                        : Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => CartItem(
                                    bloc: bloc,
                                    orderItem: bloc.order.orderItems[index],
                                    quantityController:
                                        TextEditingController(text: ""),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 2.h,
                                  ),
                                  itemCount: bloc.order.orderItems.length,
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
            bloc.order.orderItems.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 1.h, left: 2.w, right: 2.w, bottom: 2.h),
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
                      child: defaultButton(
                          onPressed: () {
                            context.push(const CompleteOrderScreen());
                          },
                          text: S.of(context).next),
                    ),
                  )
                : const SizedBox()
          ],
        );
      },
    ));
  }
}
