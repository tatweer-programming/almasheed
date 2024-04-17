import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../authentication/data/models/customer.dart';
import '../../../../authentication/presentation/components.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/constance_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../../payment/bloc/payment_bloc.dart';
import '../../../../payment/presentation/screens/cart_screen.dart';
import '../../../bloc/main_bloc.dart';
import '../../../data/models/product.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = sl();
    List<Product> favProducts = _favProducts(bloc.products);
    Customer? customer = ConstantsManager.appUser as Customer?;
    PaymentBloc? paymentBloc;
    if (customer != null) {
      paymentBloc = PaymentBloc.get(context);
    }

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                heightFactor: 0.12.h,
                child: ClipPath(
                  clipper: HalfCircleCurve(14.h),
                  child: Container(
                    height: 34.h,
                    color: ColorManager.primary,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        S.of(context).favourites,
                                        style: TextStyle(
                                          fontSize: 27.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ColorManager.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
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
                              if (ConstantsManager.appUser is Customer)
                                IconButton(
                                  onPressed: () =>
                                      context.push(const CartScreen()),
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: ColorManager.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              customer != null
                  ? BlocListener<PaymentBloc, PaymentState>(
                      bloc: paymentBloc,
                      listener: _handlePaymentBlocState,
                      child: Column(
                        children: [
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
                                return favouriteProduct(
                                  product: product,
                                  context: context,
                                  addCardPressed: () {
                                    final PaymentBloc paymentBloc =
                                        PaymentBloc.get(context);
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
                    )
                  : const ShouldLoginWidget()
            ],
          ),
        );
      },
    );
  }

  void _handlePaymentBlocState(BuildContext context, PaymentState state) {
    if (state is AddToCartSuccessState) {
      defaultToast(msg: S.of(context).productAdded);
    } else if (state is AddToCartErrorState) {
      mainErrorToast(
          msg: ExceptionManager(state.exception).translatedMessage());
    }
  }
}

List<Product> _favProducts(List<Product> products) {
  Customer? customer = ConstantsManager.appUser as Customer?;
  if (customer == null) {
    return [];
  }
  List<Product> favProducts = [];
  favProducts = products
      .where((element) => (ConstantsManager.appUser as Customer)
          .favorites
          .contains(element.productId))
      .toList();
  return favProducts;
}
