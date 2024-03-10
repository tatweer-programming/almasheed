import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/data/models/orderItem.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/color_manager.dart';
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
    return Scaffold(
      body: BlocListener<PaymentBloc, PaymentState>(
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
          } else if (state is IgnoredOrderForWorkersErrorState) {
            context.pop();
            mainErrorToast(
                msg: ExceptionManager(state.error).translatedMessage());
          } else if (state is IgnoredOrderForWorkersSuccessfullyState) {
            context.pop();
            (sl() as MainBloc).add(GetOrderForWorkersEvent());
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
          } else if (state is AcceptedOrderForWorkersErrorState) {
            context.pop();
            mainErrorToast(
                msg: ExceptionManager(state.error).translatedMessage());
          } else if (state is IgnoredOrderForWorkersSuccessfullyState) {
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
        },
        child: SingleChildScrollView(
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
                    BlocBuilder<PaymentBloc, PaymentState>(
                      builder: (context, state) {
                        PaymentBloc bloc = PaymentBloc.get();
                        return Row(
                          children: [
                            Expanded(
                              child: defaultButton(
                                onPressed: () {
                                  bloc.add(
                                    AcceptedOrderForWorkersEvent(
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
                                      orderId: orderForWorkers.orderId!,
                                    ),
                                  );
                                },
                                text: S.of(context).ignore,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}