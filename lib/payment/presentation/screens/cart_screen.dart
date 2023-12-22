import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/data/models/product.dart';
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
    Customer customer = ConstantsManager.appUser as Customer;
    MainBloc mainBloc = sl();
    List<Product> items = mainBloc.products
        .where((element) => customer.cartItems.containsKey(element.productId))
        .toList();
    PaymentBloc bloc = PaymentBloc.get(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) => CartItem(
            bloc: bloc,
            product: items[index],
            quantity: customer.cartItems[items[index].productId]!,
            quantityController: TextEditingController(text: ""),
          ),
          separatorBuilder: (context, index) => SizedBox(
            height: 5.sp,
          ),
          itemCount: items.length,
        ));
  }
}
