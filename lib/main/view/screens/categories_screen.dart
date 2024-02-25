import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/services/dep_injection.dart';
import '../../../generated/l10n.dart';
import '../../../payment/bloc/payment_bloc.dart';
import '../../bloc/main_bloc.dart';
import '../../data/models/product.dart';
import 'details_product.dart';

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
      },
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ClipPath(
                    clipper: HalfCircleCurve(10.h),
                    child: Container(
                      height: 28.h,
                      color: ColorManager.primary,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 5.h,
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
                                height: 2.h,
                              ),
                              Icon(
                                Icons.category_outlined,
                                size: 30.sp,
                                color: ColorManager.white,
                              )
                            ],
                          ),
                          SizedBox(width: 10.w,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 8.h),
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Container(
                                color: Colors.white,
                                width: 20.w,height: 5.h,
                                child: Center(child: Text(S.of(context).addCategory,style: const TextStyle(
                                  fontWeight: FontWeight.w600
                                ),),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 12.w),
                      child: Wrap(
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
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 30.w,
                color: ColorManager.primary,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _categoryName(
                        onTap: () {
                          bloc.add(ChooseCategoryEvent(
                              categoryName: bloc.categories[index].categoryName,
                              categoryProducts:
                                  bloc.categories[index].products ?? []));
                        },
                        text: bloc.categories[index].categoryName,
                        isContain: isContain,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 2.h,
                    ),
                    itemCount: bloc.categories.length,
                  ),
                ),
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
