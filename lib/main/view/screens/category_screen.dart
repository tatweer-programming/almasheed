import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';
import '../widgets/widgets.dart';
import 'details_product.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    bloc.sortedProducts = category.products??[];
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc.add(GetOffersEvent());
          bloc.add(GetCategoriesEvent());
          bloc.add(GetBestSalesEvent());
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            bloc.add(GetProductsEvent());
            bloc.add(GetMerchantsEvent());
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.sp),
                          bottomRight: Radius.circular(20.sp),
                        )),
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.w, top: 5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
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
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 7.h,
                              child: searchProductDropdownBuilder(
                                  text: "search ...",
                                  onChanged: (product) {
                                    bloc.add(
                                        SelectProductEvent(product: product!));
                                    context.push(
                                        DetailsProductScreen(product: product));
                                  },
                                  items: bloc.products,
                                  context: context),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: ColorManager.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.sp),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              bloc.add(CancelSortProductsEvent(
                                                  products: category.products!));
                                              context.pop();
                                            },
                                            child: const Text("Cancel")),
                                        TextButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: const Text("Okay")),
                                      ],
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          searchDropdownBuilder(
                                              text: "City",
                                              onChanged: (city) {
                                                bloc.add(CancelSortProductsEvent(
                                                    products: category.products!));
                                                bloc.add(SelectCityEvent(
                                                    selectedCity: city!));
                                              },
                                              items: ConstantsManager
                                                  .saudiCitiesEnglish),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sort,
                                    color: ColorManager.white,
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Text(
                                    "Sort by city",
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.sp),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                bloc.add(CancelSortProductsEvent(
                                                    products:
                                                    category.products!));
                                                context.pop();
                                              },
                                              child: const Text("Cancel")),
                                        ],
                                        content: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            iconText(
                                                onTap: () {
                                                  bloc.add(
                                                      CancelSortProductsEvent(
                                                          products: category
                                                              .products!));
                                                  bloc.add(SortProductsEvent(
                                                      type: "Offers",
                                                      products:
                                                      category.products!));
                                                  context.pop();
                                                },
                                                text: "Offers",
                                                icon: Icons.sort_by_alpha),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            iconText(
                                                onTap: () {
                                                  bloc.add(
                                                      CancelSortProductsEvent(
                                                          products: category
                                                              .products!));
                                                  bloc.add(SortProductsEvent(
                                                      type: "Best Sales",
                                                      products:
                                                      category.products!));
                                                  context.pop();
                                                },
                                                text: "Best Sales",
                                                icon: Icons.sort_by_alpha),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            iconText(
                                                onTap: () {
                                                  bloc.add(
                                                      CancelSortProductsEvent(
                                                          products: category
                                                              .products!));
                                                  bloc.add(SortProductsEvent(
                                                      type: "Alphabet",
                                                      products:
                                                      category.products!));
                                                  context.pop();
                                                },
                                                text: "Alphabet",
                                                icon: Icons.sort_by_alpha),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            iconText(
                                                onTap: () {
                                                  bloc.add(
                                                      CancelSortProductsEvent(
                                                          products: category
                                                              .products!));
                                                  bloc.add(SortProductsEvent(
                                                      type:
                                                      "Lowest to highest price",
                                                      products:
                                                      category.products!));
                                                  context.pop();
                                                },
                                                text: "Lowest to highest price",
                                                icon: Icons.arrow_upward_rounded),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            iconText(
                                                onTap: () {
                                                  bloc.add(
                                                      CancelSortProductsEvent(
                                                          products: category
                                                              .products!));
                                                  bloc.add(SortProductsEvent(
                                                      type:
                                                      "Highest to lowest price",
                                                      products:
                                                      category.products!));
                                                  context.pop();
                                                },
                                                text: "Highest to lowest price",
                                                icon:
                                                Icons.arrow_downward_rounded),
                                          ],
                                        ));
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.layers,
                                    color: ColorManager.white,
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Text(
                                    "Order by ..",
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Wrap(
                      children: bloc.sortedProducts.map((product) {
                        return productWidget(
                            openProductPressed: () {
                              context
                                  .push(DetailsProductScreen(product: product));
                            },
                            product: product,
                            addCardPressed: () {});
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget iconText(
        {required String text,
        required IconData icon,
        required VoidCallback onTap}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsetsDirectional.symmetric(vertical: 1.h, horizontal: 1.w),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(5.sp)),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 2.w,
            ),
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
