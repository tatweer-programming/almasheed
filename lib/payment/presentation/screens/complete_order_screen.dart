import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/add_address_screen.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
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
    PaymentBloc bloc = PaymentBloc.get();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_location_alt),
        onPressed: () {
          context.push(const AddAddressScreen());
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 1.h, left: 3.w, right: 3.w, bottom: 1.h),
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
                  style: const TextStyle(
                      color: ColorManager.white, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "${bloc.order.totalPrice} ",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: ColorManager.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        S.of(context).sar,
                        style: const TextStyle(
                            color: ColorManager.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.selectedAddressIndex != null
                          ? bloc.add(CompletePaymentCart(
                              context: context,
                            ))
                          : errorToast(msg: S.of(context).mustAddAddress);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                    ),
                    child: Text(
                      S.of(context).payDeposit,
                      style: const TextStyle(color: ColorManager.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: ClipPath(
                      clipper: HalfCircleCurve(18.h),
                      child: Container(
                        height: 35.h,
                        color: ColorManager.primary,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 8.w, end: 8.w, top: 1.h),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                S.of(context).completeOrder,
                                style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 3.h),
                              Icon(
                                Icons.payments_outlined,
                                color: ColorManager.white,
                                size: 40.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          bloc.add(ChooseAddress(index));
                                        },
                                        child: Stack(
                                          children: [
                                            AddressBuilder(
                                                address:
                                                    customer.addresses[index]),
                                            Align(
                                              alignment:
                                                  AlignmentDirectional.topStart,
                                              child:
                                                  bloc.selectedAddressIndex ==
                                                          index
                                                      ? const Padding(
                                                          padding:
                                                              EdgeInsets.all(
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
                                  itemCount: customer.addresses.length);
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
    );
  }
}
