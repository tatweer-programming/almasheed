import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../generated/l10n.dart';
import '../../../bloc/main_bloc.dart';
import '../../widgets/widgets.dart';

class OrderForWorkersDetailsScreen extends StatelessWidget {
  final OrderForWorkers orderForWorkers;

  const OrderForWorkersDetailsScreen(
      {super.key, required this.orderForWorkers});

  @override
  Widget build(BuildContext context) {
    TextEditingController cityController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController orderDetailsController = TextEditingController();
    TextEditingController workController = TextEditingController();
    cityController.text = orderForWorkers.city;
    locationController.text = orderForWorkers.location;
    orderDetailsController.text = orderForWorkers.orderDetails;
    workController.text = orderForWorkers.work;
    PaymentBloc bloc = PaymentBloc.get(context);
    MainBloc mainBloc = sl();
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is IgnoredOrderForWorkersLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp)),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ));
            },
          );
        }
        if (state is IgnoredOrderForWorkersErrorState) {
          context.pop();
          mainErrorToast(
              msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is IgnoredOrderForWorkersSuccessfullyState) {
          context.pop();
          context.pop();
          mainBloc.add(GetOrderForWorkersEvent());
        }
        if (state is AcceptedOrderForWorkersLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp)),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ));
            },
          );
        }
        if (state is AcceptedOrderForWorkersErrorState) {
          context.pop();
          mainErrorToast(
              msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is AcceptedOrderForWorkersSuccessfullyState) {
          mainBloc.add(GetOrderForWorkersEvent());
          context.pop();
          context.pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp)),
                content: Text(
                  S.of(context).acceptOrder,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
        }
        if (state is RemoveOrderForWorkersState) {
          mainBloc.ordersForWorkers.remove(state.order);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                appBarWidget(S.of(context).orderDetails, Icons.list_outlined),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: Column(
                    children: [
                      mainFormField(
                        controller: workController,
                        label: S.of(context).city,
                        enabled: false,
                        prefix: const Icon(
                          Icons.location_city,
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: cityController,
                        label: S.of(context).city,
                        enabled: false,
                        prefix: const Icon(
                          Icons.location_city,
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: locationController,
                        label: S.of(context).location,
                        enabled: false,
                        maxLines: 2,
                        prefix: const Icon(
                          Icons.location_pin,
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      mainFormField(
                        controller: orderDetailsController,
                        label: S.of(context).orderDetails,
                        enabled: false,
                        minLines: 8,
                        maxLines: 25,
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: defaultButton(
                              onPressed: () {
                                bloc.add(
                                  AcceptedOrderForWorkersEvent(
                                    ordersForWorkers: mainBloc.ordersForWorkers,
                                    orderForWorkers: orderForWorkers,
                                  ),
                                );
                              },
                              text: S.of(context).accept,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Expanded(
                            child: defaultButton(
                              onPressed: () {
                                bloc.add(
                                  IgnoredOrderForWorkersEvent(
                                    orderForWorkers: orderForWorkers,
                                    ordersForWorkers: mainBloc.ordersForWorkers,
                                  ),
                                );
                              },
                              text: S.of(context).ignore,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
