import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../authentication/data/models/customer.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../generated/l10n.dart';
import '../../../payment/presentation/screens/cart_screen.dart';
import '../../bloc/main_bloc.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../widgets/widgets.dart';
import 'details_product.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = sl()..sortedProducts = category.products ?? [];

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc
            ..add(GetOffersEvent())
            ..add(GetCategoriesEvent())
            ..add(GetBestSalesEvent());
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            bloc
              ..add(GetProductsEvent())
              ..add(GetMerchantsEvent());
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context, bloc),
                  _buildSortBar(context, bloc),
                  _buildProductList(context, bloc),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, MainBloc bloc) {
    return Container(
      height: 16.h,
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.sp),
          bottomRight: Radius.circular(20.sp),
        ),
      ),
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
        context.push(DetailsProductScreen(product: product));
      },
      items: bloc.products,
      context: context,
    );
  }

  Widget _buildSortBar(BuildContext context, MainBloc bloc) {
    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        color: const Color(0xffb08968),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.sp),
          bottomRight: Radius.circular(20.sp),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          children: [
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
          const Icon(
            Icons.sort,
            color: ColorManager.white,
          ),
          SizedBox(width: 1.w),
          Text(
            S.of(context).sortByCity,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
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
              child:  Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child:  Text(S.of(context).ok),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              searchDropdownBuilder(
                text: S.of(context).city,
                onChanged: (city) {
                  bloc.add(
                      CancelSortProductsEvent(products: category.products!));
                  bloc.add(SelectCityEvent(selectedCity: city!));
                },
                items: ConstantsManager.saudiCitiesEnglish,
              ),
            ],
          ),
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
          const Icon(
            Icons.layers,
            color: ColorManager.white,
          ),
          SizedBox(width: 1.w),
          Text(
            S.of(context).orderBy,
            style: TextStyle(
              color: ColorManager.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
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
              child:  Text(S.of(context).cancel),
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
                icon: Icons.sort_by_alpha,
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
                icon: Icons.sort_by_alpha,
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

  Widget _buildProductList(BuildContext context, MainBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Wrap(
        children: bloc.sortedProducts.map((product) {
          return productWidget(
            context: context,
            openProductPressed: () {
              context.push(DetailsProductScreen(product: product));
            },
            product: product,
            addCardPressed: () {},
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
