import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/main/view/screens/orders/order_for_workers_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../../payment/bloc/payment_bloc.dart';
import '../../widgets/widgets.dart';
import '../../../bloc/main_bloc.dart';

class OrdersForWorkersScreen extends StatelessWidget {
  const OrdersForWorkersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    List<OrderForWorkers> ordersForWorkers = bloc.ordersForWorkers;
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        if (state is RemoveOrderForWorkersState) {
          ordersForWorkers.remove(state.order);
        }
        return Scaffold(
          body: Column(
            children: [
              appBarWidget(
                  title: S.of(context).orders,
                  icon: Icons.list_outlined,
                  context: context),
              Expanded(
                child: BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: ordersForWorkers.length,
                      itemBuilder: (context, index) => _buildOrdersWidget(
                          onTap: () {
                            context.push(
                              OrderForWorkersDetailsScreen(
                                  orderForWorkers: ordersForWorkers[index]),
                            );
                          },
                          orderForWorkers: ordersForWorkers[index]),
                    );
                  },
                ),
              )
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
