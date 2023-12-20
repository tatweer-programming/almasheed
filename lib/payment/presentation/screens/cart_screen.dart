import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Customer _customer = ConstantsManager.appUser as Customer;
    List<Map<String, int>> itemsMaps = _customer.cartItems.entries.map((entry) {
      return {entry.key: entry.value};
    }).toList();
    MainBloc mainBloc = sl();

    PaymentBloc bloc = PaymentBloc.get(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) => CartItem(
            bloc: bloc,
            product: mainBloc.products.firstWhere((element) {
              return element.productId == itemsMaps[index].keys.first;
            }),
            quantity: itemsMaps[index].values.first,
            quantityController: TextEditingController(text: ""),
          ),
          separatorBuilder: (context, index) => SizedBox(
            height: 5.sp,
          ),
          itemCount: itemsMaps.length,
        ));
  }
}
