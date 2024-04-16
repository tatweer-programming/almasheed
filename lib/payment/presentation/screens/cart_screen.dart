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
      bloc = PaymentBloc.get(context)..add(PrepareCart());
    }
    TextEditingController quantityController = TextEditingController();

    return Scaffold(
      body: BlocBuilder<PaymentBloc, PaymentState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      appBarWidget(
                        S.of(context).cart,
                        Icons.shopping_cart_outlined,
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
                                          ? Center(
                                              child:
                                                  Text(S.of(context).noItems))
                                          : Padding(
                                              padding: EdgeInsets.all(5.0.w),
                                              child: Column(
                                                children: [
                                                  BlocBuilder<PaymentBloc,
                                                      PaymentState>(
                                                    bloc: bloc,
                                                    builder: (context, state) {
                                                      return ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder: (context,
                                                                index) =>
                                                            CartItem(
                                                                bloc: bloc!,
                                                                orderItem: bloc
                                                                        .order
                                                                        .orderItems[
                                                                    index],
                                                                quantityController:
                                                                    quantityController),
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        itemCount: bloc!.order
                                                            .orderItems.length,
                                                      );
                                                    },
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
                          : const ShouldLoginWidget(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: (customer != null)
          ? BlocBuilder<PaymentBloc, PaymentState>(
              bloc: bloc,
              builder: (context, state) {
                return bloc!.order.orderItems.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(5.w),
                        child: Container(
                          height: 8.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(10.sp)),
                            color: ColorManager.primary,
                          ),
                          child: defaultButton(
                              onPressed: () {
                                context.push(const CompleteOrderScreen());
                              },
                              text: S.of(context).next,
                              fontSize: 18.sp),
                        ),
                      )
                    : const SizedBox();
              },
            )
          : null,
    );
  }

  void _handlePaymentBlocState(BuildContext context, PaymentState state) {
    PaymentBloc bloc = PaymentBloc.get(context);
    if (state is AddToCartSuccessState) {
      bloc.add(PrepareCart());
      defaultToast(msg: S.of(context).productAdded);
    } else if (state is AddToCartErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    } else if (state is EditQuantityInCartSuccessState) {
      bloc.add(PrepareCart());
      defaultToast(msg: S.of(context).updatedSuccessfully);
    } else if (state is EditQuantityInCartErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    } else if (state is RemoveFromCartSuccessState) {
      bloc.add(PrepareCart());
      defaultToast(msg: S.of(context).deletedSuccessfully);
    } else if (state is RemoveFromCartErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    }
  }
}
