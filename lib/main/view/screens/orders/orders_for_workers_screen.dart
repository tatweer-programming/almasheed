import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/screens/orders/order_for_workers_details_screen.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/data/models/orderItem.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../generated/l10n.dart';
import '../../widgets/widgets.dart';
import '../../../bloc/main_bloc.dart';

class OrdersForWorkersScreen extends StatelessWidget {
  const OrdersForWorkersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    return Scaffold(
      body: Column(
        children: [
          appBarWidget(S.of(context).orders, Icons.list_outlined),
          Expanded(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: bloc.ordersForWorkers.length,
                  itemBuilder: (context, index) =>
                      _buildOrdersWidget(
                          onTap: () {
                            context.push(
                              OrderForWorkersDetailsScreen(
                                  orderForWorkers: bloc.ordersForWorkers[index]),
                            );
                          },
                          orderForWorkers: bloc.ordersForWorkers[index]),
                );
              },
            ),
          )
        ],
      ),
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
