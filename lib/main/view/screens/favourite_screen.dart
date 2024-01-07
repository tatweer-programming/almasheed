import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../authentication/data/models/customer.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../generated/l10n.dart';
import '../../../payment/bloc/payment_bloc.dart';
import '../../../payment/presentation/screens/cart_screen.dart';
import '../../bloc/main_bloc.dart';
import '../../data/models/product.dart';
import 'details_product.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = sl();
    List<Product> favProducts = _favProducts(bloc.products);
    final PaymentBloc paymentBloc = PaymentBloc.get(context);
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: HalfCircleCurve(10.h),
                child: Container(
                  height: 28.h,
                  color: ColorManager.primary,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 14.w),
                                child: Text(
                                  S.of(context).favourites,
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: ColorManager.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (ConstantsManager.appUser is Customer)
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: IconButton(
                                onPressed: () => context.push(const CartScreen()),
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: ColorManager.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Icon(
                        Icons.favorite_outlined,
                        size: 30.sp,
                        color: ColorManager.white,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: favProducts.map((product) {
                    return productVerticalWidget(
                      openProductPressed: () {
                        context.push(DetailsProductScreen(product: product));
                      },
                      product: product,
                      context: context,
                      addCardPressed: () {
                        paymentBloc.add(
                          AddToCartEvent(
                            productId: product.productId,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

List<Product> _favProducts(List<Product> products) {
  List<Product> favProducts = [];
  favProducts = products
      .where((element) => (ConstantsManager.appUser as Customer)
          .favorites
          .contains(element.productId))
      .toList();
  return favProducts;
}
