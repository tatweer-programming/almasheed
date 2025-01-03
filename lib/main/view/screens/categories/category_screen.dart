import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../authentication/data/models/customer.dart';
import '../../../../authentication/presentation/components.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/constance_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../../payment/presentation/screens/cart_screen.dart';
import '../../../bloc/main_bloc.dart';
import '../../../data/models/category.dart';
import '../../../data/models/product.dart';
import '../../widgets/widgets.dart';
import '../products/details_product.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = sl()..sortedProducts = category.products ?? [];
    bool isHorizontal = false;
    List<TextEditingController> quantityController = List.generate(
      mainBloc.sortedProducts.length,
      (index) => TextEditingController(),
    );
    return BlocListener<PaymentBloc, PaymentState>(
      listener: _handlePaymentBlocState,
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if (state is GetProductsSuccessfullyState) {
            mainBloc
              ..add(GetOffersEvent())
              ..add(GetCategoriesEvent())
              ..add(GetBestSalesEvent());
          }
          if (state is ChangeShowingProductsState) {
            isHorizontal = state.isHorizontal;
          }
          if (state is IncreaseQuantityState) {
            quantityController[state.index].text = state.quantity.toString();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              mainBloc.add(GetProductsEvent());
            },
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAppBar(context, mainBloc),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    _buildSortBar(context, mainBloc, isHorizontal),
                    _buildProductList(
                      context: context,
                      isHorizontal: isHorizontal,
                      mainBloc: mainBloc,
                      quantityController: quantityController,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePaymentBlocState(
    BuildContext context,
    PaymentState state,
  ) {
    if (state is AddToCartSuccessState) {
      defaultToast(msg: S.of(context).productAdded);
    } else if (state is AddToCartErrorState) {
      mainErrorToast(
          msg: ExceptionManager(state.exception).translatedMessage());
    }
  }

  Widget _buildAppBar(BuildContext context, MainBloc bloc) {
    return Container(
      height: 16.h,
      color: ColorManager.primary,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w, top: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorManager.white,
              ),
            ),
            Text(
              category.categoryName,
              style: TextStyle(
                color: ColorManager.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: SizedBox(
                height: 7.h,
                child: _buildSearchDropdown(context, bloc),
              ),
            ),
            SizedBox(width: 3.w),
            if (ConstantsManager.appUser is Customer)
              IconButton(
                onPressed: () => context.push(const CartScreen()),
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: ColorManager.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchDropdown(BuildContext context, MainBloc bloc) {
    return searchProductDropdownBuilder(
      text: S.of(context).search,
      onChanged: (product) {
        bloc.add(SelectProductEvent(product: product!));
        context.push(DetailsProductScreen(
          product: product,
          products: ConstantsManager.appUser is Customer ? category.products??[] : bloc.merchantProducts,
        ));
      },
      items: ConstantsManager.appUser is Customer ? category.products??[] : bloc.merchantProducts,
      context: context,
    );
  }

  Widget _buildSortBar(BuildContext context, MainBloc bloc, bool isHorizontal) {
    return Container(
      height: 7.h,
      color: const Color(0xffac793d),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                bloc.add(
                    ChangeShowingProductsEvent(isHorizontal: isHorizontal));
              },
              icon: Icon(
                isHorizontal
                    ? Icons.horizontal_distribute
                    : Icons.vertical_distribute,
                color: ColorManager.white,
              ),
            ),
            Expanded(child: _buildSortByCity(context, bloc)),
            Expanded(child: _buildOrderBy(context, bloc)),
          ],
        ),
      ),
    );
  }

  Widget _buildSortByCity(BuildContext context, MainBloc bloc) {
    return InkWell(
      onTap: () {
        _showSortByCityDialog(context, bloc);
      },
      child: Row(
        children: [
          const Expanded(
            child: Icon(
              Icons.sort,
              color: ColorManager.white,
            ),
          ),
          SizedBox(width: 1.w),
          Expanded(
            child: Text(
              S.of(context).sortByCity,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorManager.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortByCityDialog(BuildContext context, MainBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    bloc.add(
                        CancelSortProductsEvent(products: category.products!));
                    context.pop();
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(S.of(context).ok),
                ),
              ],
              content: searchDropdownBuilder(
                text: S.of(context).city,
                onChanged: (city) {
                  bloc.add(
                      CancelSortProductsEvent(products: category.products!));
                  bloc.add(SelectCityEvent(selectedCity: city!));
                },
                items: ConstantsManager.getSaudiCities,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderBy(BuildContext context, MainBloc bloc) {
    return InkWell(
      onTap: () {
        _showOrderByDialog(context, bloc);
      },
      child: Row(
        children: [
          const Expanded(
            child: Icon(
              Icons.layers,
              color: ColorManager.white,
            ),
          ),
          SizedBox(width: 1.w),
          Expanded(
            child: Text(
              S.of(context).orderBy,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorManager.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderByDialog(BuildContext context, MainBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                bloc.add(CancelSortProductsEvent(products: category.products!));
                context.pop();
              },
              child: Text(S.of(context).cancel),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconText(
                onTap: () {
                  _onSortByType(
                      context: context,
                      bloc: bloc,
                      type: "Offers",
                      products: category.products!);
                },
                text: S.of(context).offers,
                icon: Icons.local_offer,
              ),
              SizedBox(height: 1.h),
              _buildIconText(
                onTap: () {
                  _onSortByType(
                      context: context,
                      bloc: bloc,
                      type: "Best Sales",
                      products: category.products!);
                },
                text: S.of(context).bestSales,
                icon: Icons.vertical_align_top_outlined,
              ),
              SizedBox(height: 1.h),
              _buildIconText(
                onTap: () {
                  _onSortByType(
                      context: context,
                      bloc: bloc,
                      type: "Alphabet",
                      products: category.products!);
                },
                text: S.of(context).alphabet,
                icon: Icons.sort_by_alpha,
              ),
              SizedBox(height: 1.h),
              _buildIconText(
                onTap: () {
                  _onSortByType(
                      context: context,
                      bloc: bloc,
                      type: "Lowest to highest price",
                      products: category.products!);
                },
                text: S.of(context).lowestToHighestPrice,
                icon: Icons.arrow_upward_rounded,
              ),
              SizedBox(height: 1.h),
              _buildIconText(
                onTap: () {
                  _onSortByType(
                      context: context,
                      bloc: bloc,
                      type: "Highest to lowest price",
                      products: category.products!);
                },
                text: S.of(context).highestToLowestPrice,
                icon: Icons.arrow_downward_rounded,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconText({
    required VoidCallback onTap,
    required String text,
    required IconData icon,
  }) {
    return iconText(
      onTap: onTap,
      text: text,
      icon: icon,
    );
  }

  Widget _buildProductList({
    required BuildContext context,
    required MainBloc mainBloc,
    required bool isHorizontal,
    required List<TextEditingController> quantityController,
  }) {
    PaymentBloc paymentBloc = PaymentBloc.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Wrap(
        direction: Axis.horizontal,
        children: mainBloc.sortedProducts.asMap().entries.map((entry) {
          final int index = entry.key;
          final Product product = entry.value;
          if (isHorizontal) {
            return productHorizontalWidget(
              openProductPressed: () {
                context.push(DetailsProductScreen(
                  product: product,
                  products: category.products ?? [],
                ));
              },
              product: product,
            );
          }
          return categoryProductsVerticalWidget(
            controller: quantityController[index],
            openProductPressed: () {
              context.push(DetailsProductScreen(
                product: product,
                products: category.products ?? [],
              ));
            },
            product: product,
            addCardPressed: () {
              mainBloc.add(
                IncreaseQuantityEvent(
                  quantity: int.parse(quantityController[index].text),
                  index: index,
                ),
              );
              paymentBloc.add(
                AddToCartEvent(
                  productId: product.productId,
                  quantity: int.parse(quantityController[index].text) + 1,
                ),
              );
            },
            context: context,
          );
        }).toList(),
      ),
    );
  }
}

Widget iconText({
  required VoidCallback onTap,
  required String text,
  required IconData icon,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: 1.h, horizontal: 1.w),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    ),
  );
}

void _onSortByType(
    {required BuildContext context,
    required MainBloc bloc,
    required String type,
    required List<Product> products}) {
  bloc.add(CancelSortProductsEvent(products: products));
  bloc.add(SortProductsEvent(type: type, products: products));
  context.pop();
}
