import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/categories/add_category_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../generated/l10n.dart';
import '../../../../payment/bloc/payment_bloc.dart';
import '../../../bloc/main_bloc.dart';
import '../../../data/models/product.dart';
import '../products/add_product_screen.dart';
import 'all_categories_screen.dart';
import '../products/details_product.dart';
import 'package:almasheed/core/utils/constance_manager.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = sl();
    List<Product> categoryProducts = [];
    String isContain = "";
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is ChooseCategoryState) {
          categoryProducts = state.categoryProducts;
          isContain = state.categoryName;
        }
        if (state is SelectAddProductState) {
          context.push(const AddProductScreen());
        } else if (state is SelectAddCategoryState) {
          context.push(const AddCategoryScreen());
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 20.h,
                    color: ColorManager.primary,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: ConstantsManager.appUser is! Customer
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 6.h,
                            ),
                            Text(
                              S.of(context).categories,
                              style: TextStyle(
                                fontSize: 25.sp,
                                color: ColorManager.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Icon(
                              Icons.category_outlined,
                              size: 30.sp,
                              color: ColorManager.white,
                            )
                          ],
                        ),
                        SizedBox(
                          width:
                              (ConstantsManager.appUser is Customer ? 0 : 15).w,
                        ),
                        if (ConstantsManager.appUser is! Customer)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 8.h),
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Container(
                                color: Colors.white,
                                width: 15.w,
                                height: 5.h,
                                child: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                  onSelected: (String value) {
                                    bloc.add(SelectAddProductOrAddCategoryEvent(
                                        selected: value));
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'AddProduct',
                                      child: Text(S.of(context).addProduct),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'AddCategory',
                                      child: Text(S.of(context).addCategory),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    color: ColorManager.secondary,
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                children: bloc.categories
                                    .map((category) {
                                      return _categoryName(
                                        onTap: () {
                                          bloc.add(ChooseCategoryEvent(
                                              categoryName:
                                                  category.categoryName,
                                              categoryProducts:
                                                  category.products ?? []));
                                        },
                                        text: category.categoryName,
                                        isContain: isContain,
                                      );
                                    })
                                    .take(3)
                                    .toList(),
                              ),
                            ],
                          ),
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                context.push(AllCategoriesScreen());
                              },
                              child: Text(S.of(context).showMore))
                        ],
                      ),
                    ),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: categoryProducts.map((product) {
                      return productVerticalWidget(
                        openProductPressed: () {
                          context.push(DetailsProductScreen(
                            product: product,
                            products: categoryProducts,
                          ));
                        },
                        product: product,
                        context: context,
                        addCardPressed: () {
                          final PaymentBloc paymentBloc = PaymentBloc.bloc;
                          paymentBloc.add(
                            AddToCartEvent(
                              productId: product.productId,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _categoryName(
    {required String text,
    required VoidCallback onTap,
    required String isContain}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
      child: Container(
        width: 18.w,
        height: 5.h,
        decoration:
            BoxDecoration(border: Border.all(), color: ColorManager.white),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color:
                    isContain == text ? ColorManager.black : ColorManager.grey2,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ),
  );
}
