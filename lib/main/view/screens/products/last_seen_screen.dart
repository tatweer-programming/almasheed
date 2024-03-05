import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../../payment/bloc/payment_bloc.dart';
import '../../../bloc/main_bloc.dart';
import 'details_product.dart';

class LastSeenScreen extends StatelessWidget {
  const LastSeenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    return Scaffold(
      body:  BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  clipper: HalfCircleCurve(18.h),
                  child: Container(
                    height: 35.h,
                    width: double.infinity,
                    color: ColorManager.primary,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            S.of(context).lastSeen,
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Icon(
                              Icons.remove_red_eye_rounded,
                              color: ColorManager.white,
                              size: 40.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildProductList(
                    context: context,
                    mainBloc: bloc
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildProductList({
  required BuildContext context,
  required MainBloc mainBloc,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
    child: Wrap(
      direction: Axis.horizontal,
      children: mainBloc.lastSeenProducts.map((product) {
        return productVerticalWidget(
          openProductPressed: () {
            context.push(DetailsProductScreen(product: product, products: mainBloc.products,));
          },
          product: product,
          addCardPressed: () {
            PaymentBloc paymentBloc = PaymentBloc.bloc;
            paymentBloc.add(
              AddToCartEvent(
                productId: product.productId,
              ),
            );
          },
          context: context,
        );
      }).toList(),
    ),
  );
}