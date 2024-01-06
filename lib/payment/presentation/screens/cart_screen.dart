import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/localization_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer customer = ConstantsManager.appUser as Customer;
    MainBloc mainBloc = sl();

    print(customer.cartItems.toString() + "(((((((((((((((((((((((((((((");

    PaymentBloc bloc = PaymentBloc.get(context);
    return Scaffold(
        appBar: AppBar(
          title:  InkWell(
              onTap: () async {
               mainBloc.add( ChangeLocaleEvent(LocalizationManager.currentLocale == 0 ? 1 : 0));

              },
              child: Text(S.of(context).cart)),
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
        ),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          bloc: bloc,
          builder: (context, state) {
            List<Product> items = mainBloc.products
                .where((element) =>
                customer.cartItems.containsKey(element.productId))
                .toList();
            return items.isEmpty
                ?  Center(child: Text(S.of(context).noItems))
                : Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => CartItem(
                        bloc: bloc,
                        product: items[index],
                        quantity: customer.cartItems[items[index].productId]?? 1,
                        quantityController: TextEditingController(text: ""),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5.sp,
                      ),
                      itemCount: items.length,
                    ),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.sp,
                      ),
                    ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${S.of(context).totalPrice}: ",
                            style: TextStyle(
                                color: ColorManager.white,

                                fontWeight: FontWeight.bold),
                          ),
                   Expanded(child: Row(
                     children: [
                       Text(
                                "${bloc.getTotalPrice()} ",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                    color: ColorManager.white,
                                    fontWeight: FontWeight.bold),
                              ),
                       Text(
                         S.of(context).sar,
                         style: TextStyle(
                             color: ColorManager.white,

                             fontWeight: FontWeight.bold),
                       ),
                     ],
                   ),),
                          FittedBox(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: ColorManager.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                              ),
                              child: Text(S.of(context).payDeposit),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
