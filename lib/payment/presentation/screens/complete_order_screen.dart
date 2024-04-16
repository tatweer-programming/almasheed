import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/add_address_screen.dart';
import 'package:almasheed/chat/presentation/screens/chats_screen.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../../core/utils/font_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/widgets/widgets.dart';

class CompleteOrderScreen extends StatelessWidget {
  const CompleteOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer customer = ConstantsManager.appUser as Customer;
    PaymentBloc bloc = PaymentBloc.get(context);
    OrderModel orderModel = bloc.order;
    return BlocListener<PaymentBloc, PaymentState>(
      bloc: bloc,
      listener: _handlePaymentBlocState,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_location_alt),
          onPressed: () {
            context.push(const AddAddressScreen());
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(5.w),
          child: Container(
            height: 8.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(10.sp)),
              color: ColorManager.primary,
            ),
            child: defaultButton(
                onPressed: () {
                  bloc.selectedAddressIndex != null
                      ? bloc.add(CompletePaymentCart(
                          context: context,
                          totalPrice: orderModel.totalPrice / 10,
                        ))
                      : errorToast(msg: S.of(context).mustAddAddress);
                },
                text: S.of(context).payDeposit,
                fontSize: 18.sp),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    appBarWidget(
                        S.of(context).completeOrder, Icons.payments_outlined),
                    SizedBox(height: 1.h),
                    Text(
                      S.of(context).chooseAddress,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeightManager.bold,
                          color: ColorManager.black),
                    ),
                    customer.addresses.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(5.w),
                            child: BlocBuilder<PaymentBloc, PaymentState>(
                              bloc: bloc,
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                              onTap: () {
                                                bloc.add(ChooseAddress(index));
                                              },
                                              child: Stack(
                                                children: [
                                                  AddressBuilder(
                                                      address: customer
                                                          .addresses[index]),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child:
                                                        bloc.selectedAddressIndex ==
                                                                index
                                                            ? const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .check_circle_rounded,
                                                                  color: ColorManager
                                                                      .primary,
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                  )
                                                ],
                                              ),
                                            ),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: 10.sp,
                                            ),
                                        itemCount: customer.addresses.length),
                                    ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        OrderDetailsItem(
                                            title: S.of(context).totalElements,
                                            value: orderModel.orderItems.length
                                                .toString()),
                                        OrderDetailsItem(
                                            title: S.of(context).totalValue,
                                            value: orderModel.totalPrice
                                                    .toString() +
                                                S.of(context).sar),
                                        OrderDetailsItem(
                                            title: S.of(context).deposit,
                                            value: (orderModel.totalPrice / 10)
                                                    .toString() +
                                                S.of(context).sar),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(S.of(context).mustChooseAddress),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentBlocState(BuildContext context, PaymentState state) {
    if (state is CompleteOrderSuccessState) {
      context.push(const ChatsScreen());
    } else if (state is CompleteOrderErrorState) {}
  }
}
