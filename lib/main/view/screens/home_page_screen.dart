import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/services/dep_injection.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/view/screens/category_screen.dart';
import 'package:almasheed/main/view/screens/details_product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../generated/l10n.dart';
import '../../../payment/bloc/payment_bloc.dart';
import '../../../payment/presentation/screens/cart_screen.dart';
import '../../bloc/main_bloc.dart';

List<String> list = [
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIy4RZNPjkGfpN7itM2sEbE7g7sm76WGELCQ&usqp=CAU",
  "https://gate.ahram.org.eg/Media/News/2023/7/8/19_2023-638244132690781587-78.JPG"
];

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselController carouselController = CarouselController();
    final MainBloc bloc = sl();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          _handleProductSuccessState(context, bloc);
        } else if (state is GetProductsErrorState ||
            state is GetMerchantsErrorState ||
            state is GetOffersErrorState ||
            state is GetBestSalesErrorState ||
            state is GetCategoriesErrorState) {
          _handleErrorState(context, state);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            _buildAppBar(context, bloc),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: BlocBuilder<MainBloc, MainState>(
                    bloc: bloc,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          defaultCarousel(bloc: bloc, list: list, controller: carouselController),
                          SizedBox(height: 1.h),
                          if (bloc.categories.isNotEmpty) _buildCategoriesList(context, bloc),
                          if ((ConstantsManager.appUser is Customer ||
                                  ConstantsManager.appUser == null) &&
                              (bloc.merchants.isNotEmpty))
                            _buildMerchantsList(context, bloc),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h,),
          ],
        );
      },
    );
  }

  void _handleProductSuccessState(BuildContext context, MainBloc bloc) {
    bloc
      ..add(GetOffersEvent())
      ..add(GetCategoriesEvent())
      ..add(GetBestSalesEvent());
  }

  void _handleErrorState(BuildContext context, state) {
    context.pop();
    mainErrorToast(msg: ExceptionManager(state.error).translatedMessage());
  }

  Widget _buildAppBar(BuildContext context, MainBloc bloc) {
    return Stack(
      alignment: const Alignment(0, 0.7),
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipPath(
              clipper: HalfCircleCurve(18.h),
              child: Container(
                height: 35.h,
                color: ColorManager.primary,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: searchProductDropdownBuilder(
                          text: S.of(context).search,
                          onChanged: (product) {
                            bloc.add(SelectProductEvent(product: product!));
                            context.push(DetailsProductScreen(
                              product: product,
                              products: bloc.products,
                            ));
                          },
                          items: bloc.products,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: HalfCircleCurve(13.h),
              child: ClipPath(
                clipper: RainBowCurve(),
                child: Container(
                  height: 15.h,
                  color: ColorManager.primary,
                ),
              ),
            )
          ],
        ),
        InkWell(
          onTap: () {
            if (ConstantsManager.appUser is Customer)
           context.push(const CartScreen());
          },
          customBorder: const CircleBorder(),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: ColorManager.primary,
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: ColorManager.grey2,
                backgroundImage: AssetImage("assets/images/cart.png"),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    MainBloc bloc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textContainerWidget(S.of(context).categories),
        SizedBox(height: 1.h),
        SizedBox(
          height: 14.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => categoryWidget(
              onTap: () => context.push(CategoryScreen(
                category: ConstantsManager.appUser is Customer || ConstantsManager.appUser == null
                    ? bloc.categories[index]
                    : Category(
                        categoryName: "",
                        products: bloc.categories[index].products!
                            .where((product) => (ConstantsManager.appUser as Merchant)
                                .productsIds
                                .contains(product.productId))
                            .toList(),
                        productsIds: (ConstantsManager.appUser as Merchant).productsIds,
                      ),
              )),
              category: bloc.categories[index],
            ),
            separatorBuilder: (context, index) => SizedBox(width: 5.w),
            itemCount: bloc.categories.length,
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantsList(BuildContext context, MainBloc bloc) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        textContainerWidget(S.of(context).merchants),
        SizedBox(height: 1.h),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => merchantWidget(
            merchant: bloc.merchants[index],
            onTap: () => context.push(CategoryScreen(
              category: Category(
                categoryName: bloc.merchants[index].companyName,
                products: bloc.products
                    .where(
                        (product) => bloc.merchants[index].productsIds.contains(product.productId))
                    .toList(),
                productsIds: bloc.merchants[index].productsIds,
              ),
            )),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemCount: bloc.merchants.length,
        ),
      ],
    );
  }
}

class RainBowCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.quadraticBezierTo(size.width / 2, size.height, size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

// class CurveClipper2 extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path
//       ..moveTo(size.width / 2, size.height)  // Move to the bottom center
//       ..arcToPoint(
//         Offset(size.width, 0),  // Top-right corner
//         radius: Radius.circular(50.w),
//         clockwise: false,  // Counter-clockwise arc
//       )
//       ..lineTo(0, 0)  // Top-left corner
//       ..arcToPoint(
//         Offset(size.width / 2, size.height),  // Bottom center
//         radius: Radius.circular(50.w),
//         clockwise: false,  // Counter-clockwise arc
//       )
//       ..moveTo(size.width / 2, 0)
//       ..arcToPoint(Offset(size.width, size.height),
//           radius: Radius.circular(50.w))
//       ..lineTo(0, size.height)
//       ..arcToPoint(
//         Offset(size.width / 2, 0),
//         radius: Radius.circular(50.w),
//       )
//       ..close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }
