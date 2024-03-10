import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/main/view/screens/orders/order_for_workers_details_screen.dart';
import 'package:almasheed/main/view/screens/worker_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../authentication/data/models/worker.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/widgets/widgets.dart';
import '../../bloc/payment_bloc.dart';

class CompleteOrderForWorkers extends StatelessWidget {
  final OrderForWorkers orderForWorkers;

  const CompleteOrderForWorkers({super.key, required this.orderForWorkers});

  @override
  Widget build(BuildContext context) {
    MainBloc mainBloc = sl();
    Worker worker = mainBloc.workers.firstWhere(
      (worker) => worker.id == orderForWorkers.workersIds.first,
    );
    PaymentBloc paymentBloc = PaymentBloc.get();
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            child: Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadiusDirectional.all(Radius.circular(10.sp)),
                color: ColorManager.primary,
              ),
              child: defaultButton(
                  onPressed: () {
                    paymentBloc.add(CompletePaymentCart(
                      context: context,
                      totalPrice: 20,
                      orderForWorkers: orderForWorkers,
                    ));
                  },
                  text: S.of(context).payDeposit,
                  fontSize: 18.sp),
            ),
          ),
          body: Column(
            children: [
              appBarWidget(S.of(context).completeOrder, Icons.payment),
              Text(
                "${S.of(context).acceptOrderFrom} ${worker.name}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: defaultButton(
                    onPressed: () {
                      context.push(WorkerDetailsScreen(worker: worker));
                    },
                    text: S.of(context).workerDetails),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildOrdersWidget(
    {required VoidCallback onTap, required OrderForWorkers orderForWorkers}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
      child: Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide.none),
        elevation: 4.sp,
        child: Container(
            width: double.infinity,
            height: 7.h,
            decoration: BoxDecoration(
                color: ColorManager.secondary,
                borderRadius: BorderRadiusDirectional.circular(10.sp)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.work),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Text(
                            orderForWorkers.work,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.location_city),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Text(
                            orderForWorkers.city,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_sharp),
                ],
              ),
            )),
      ),
    ),
  );
}