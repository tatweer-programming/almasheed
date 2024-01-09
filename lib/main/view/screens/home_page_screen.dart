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
import '../../../payment/presentation/screens/cart_screen.dart';
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      defaultCarousel(
                          bloc: bloc,
                          list: list,
                          controller: carouselController),
                      SizedBox(height: 1.h),
                      if (bloc.categories.isNotEmpty)
                        _buildCategoriesList(context, bloc),
                      if (ConstantsManager.appUser is Customer &&
                          bloc.merchants.isNotEmpty)
                        _buildMerchantsList(context, bloc),
                    ],
                  ),
                ),
              ),
            ),
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
                  padding: EdgeInsetsDirectional.only(
                      start: 8.w, end: 8.w, top: 1.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 7.h,
                              child: searchProductDropdownBuilder(
                                text: S.of(context).search,
                                onChanged: (product) {
                                  bloc.add(
                                      SelectProductEvent(product: product!));
                                  context.push(
                                      DetailsProductScreen(product: product));
                                },
                                items: bloc.products,
                                context: context,
                              ),
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
        const CircleAvatar(
          radius: 50,
          backgroundColor: ColorManager.grey2,
          backgroundImage: AssetImage("assets/images/building_1.png"),
        )
      ],
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    MainBloc bloc,
  ) {
    Merchant? merchant;
    if (ConstantsManager.appUser is Merchant) {
      merchant = ConstantsManager.appUser as Merchant;
    }
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
                category: ConstantsManager.appUser is Customer
                    ? bloc.categories[index]
                    : Category(
                        categoryName: "",
                        products: bloc.categories[index].products!
                            .where((product) => merchant!.productsIds
                                .contains(product.productId))
                            .toList(),
                        productsIds: merchant!.productsIds,
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
                categoryName: "",
                products: bloc.products
                    .where((product) => bloc.merchants[index].productsIds
                        .contains(product.productId))
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
