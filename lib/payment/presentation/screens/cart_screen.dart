import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:almasheed/payment/presentation/screens/complete_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../authentication/presentation/components.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer? customer = ConstantsManager.appUser as Customer?;
    PaymentBloc? bloc;
    if (customer != null) {
      bloc = PaymentBloc.get()..add(PrepareCart());
    }
    TextEditingController quantityController = TextEditingController();

    return Scaffold(
        body: Column(
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
                        padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
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
                customer != null
                    ? BlocListener<PaymentBloc, PaymentState>(
                        bloc: bloc,
                        listener: _handlePaymentBlocState,
                        child: BlocBuilder<PaymentBloc, PaymentState>(
                          bloc: bloc,
                          builder: (context, state) {
                            return Column(
                              children: [
                                bloc!.order.orderItems.isEmpty
                                    ? Center(child: Text(S.of(context).noItems))
                                    : Padding(
                                        padding: EdgeInsets.all(5.0.w),
                                        child: Column(
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) => CartItem(
                                                  bloc: bloc!,
                                                  orderItem: bloc.order.orderItems[index],
                                                  quantityController: quantityController),
                                              separatorBuilder: (context, index) => SizedBox(
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
                            );
                          },
                        ),
                      )
                    : LoginWidget(),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  void _handlePaymentBlocState(BuildContext context, PaymentState state) {
    if (state is AddToCartSuccessState) {
      defaultToast(msg: S.of(context).productAdded);
    } else if (state is AddToCartErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    } else if (state is EditQuantityInCartSuccessState) {
      defaultToast(msg: S.of(context).updatedSuccessfully);
    } else if (state is EditQuantityInCartErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    } else if (state is RemoveFromCartSuccessState) {
      defaultToast(msg: S.of(context).deletedSuccessfully);
    } else if (state is RemoveFromCartErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    }
  }
}
