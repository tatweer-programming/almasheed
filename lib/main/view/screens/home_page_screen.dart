import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/view/screens/category_screen.dart';
import 'package:almasheed/main/view/screens/details_product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:almasheed/payment/presentation/screens/cart_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';

List<String> list = [
  "https://static.independent.co.uk/s3fs-public/thumbnails/image/2015/10/19/11/attack-on-titan.jpg",
  "https://www.cnet.com/a/img/resize/597f8167c5bc132e301df0e4052180b26b5e4c7d/hub/2022/01/07/18439ff0-d202-4d93-b233-3e203a7617fd/aot-f2-pv02-00-01-11-06-still075.jpg?auto=webp&fit=crop&height=675&width=1200",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK_dpI9V5LsmeCAWth-VVt4LCJ4-uQq7Tr6w&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhZHbbrSxPuCzOdrugXgNjG5tS3Cp1J3uE1i2qBcsPcuPi7LtvzeVXrTwBPvqiNX7vkEg&usqp=CAU",
];

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    MainBloc bloc = sl();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc.add(GetOffersEvent());
          bloc.add(GetCategoriesEvent());
          bloc.add(GetBestSalesEvent());
        }
        if (state is GetProductsErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is GetMerchantsErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is GetOffersErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is GetBestSalesErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is GetCategoriesErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
      },
      builder: (context, state) {
        return Column(
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
                padding:
                    EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 7.h,
                        child: searchProductDropdownBuilder(
                            text: "search ...",
                            onChanged: (product) {
                              bloc.add(SelectProductEvent(product: product!));
                              context
                                  .push(DetailsProductScreen(product: product));
                            },
                            items: bloc.products,
                            context: context),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    IconButton(
                        onPressed: () {
                          context.push(const CartScreen());
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: ColorManager.white,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    defaultCarousel(list: list, controller: carouselController),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          bloc.categories.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textContainerWidget("Categories"),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(
                                      height: 14.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            categoryWidget(
                                                onTap: () {
                                                  context.push(CategoryScreen(
                                                    category:
                                                        bloc.categories[index],
                                                  ));
                                                },
                                                category:
                                                    bloc.categories[index]),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 5.w,
                                        ),
                                        itemCount: bloc.categories.length,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 1.h,
                          ),
                          textContainerWidget("Merchants"),
                          SizedBox(
                            height: 1.h,
                          ),
                          ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => merchantsWidget(
                                  merchant: bloc.merchants[index],
                                  onTap: () {
                                    context.push(CategoryScreen(
                                        category: Category(
                                            categoryName: "",
                                            products: bloc.products
                                                .where((product) => bloc
                                                    .merchants[index]
                                                    .productsIds
                                                    .contains(
                                                        product.productId))
                                                .toList(),
                                            productsIds: bloc.merchants[index]
                                                .productsIds)));
                                  }),
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 1.h,
                                  ),
                              itemCount: bloc.merchants.length)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
