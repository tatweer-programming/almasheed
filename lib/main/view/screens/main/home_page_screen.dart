import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/main/view/screens/show_all_merchants_or_workers_screen.dart';
import 'package:almasheed/main/view/screens/worker_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/services/dep_injection.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/view/screens/categories/category_screen.dart';
import 'package:almasheed/main/view/screens/products/details_product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../authentication/data/models/worker.dart';
import '../../../../generated/l10n.dart';
import '../../../../payment/presentation/screens/cart_screen.dart';
import '../../../bloc/main_bloc.dart';

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
        }
        if (state is GetCategoriesSuccessfullyState) {
          bloc.add(MerchantProductsEvent());
        } else if (state is GetProductsErrorState ||
            state is GetMerchantsErrorState ||
            state is GetOffersErrorState ||
            state is GetBestSalesErrorState ||
            state is GetCategoriesErrorState) {
          _handleErrorState(context, state);
        }
        if (state is GetUserDataSuccessfullyState &&
            ConstantsManager.appUser is! Merchant) {
          bloc.add(GetOrderForWorkersEvent());
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            _buildAppBar(context, bloc),
            Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return builder(bloc, carouselController);
                  },
                  itemCount: 1,
                )),
          ],
        );
      },
    );
  }

  Widget builder(MainBloc bloc, CarouselController carouselController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: BlocBuilder<MainBloc, MainState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              defaultCarousel(
                  bloc: bloc,
                  list: bloc.banners,
                  controller: carouselController),
              SizedBox(height: 1.h),
              if (ConstantsManager.appUser is! Worker &&
                  bloc.categories.isNotEmpty)
                _buildCategoriesList(context, bloc),
              if ((ConstantsManager.appUser is Customer ||
                  ConstantsManager.appUser == null) &&
                  (bloc.merchants.isNotEmpty))
                _buildMerchantsList(context, bloc),
              if ((ConstantsManager.appUser is Customer ||
                  ConstantsManager.appUser == null) &&
                  (bloc.workers.isNotEmpty))
                _buildWorkersList(context, bloc),
            ],
          );
        },
      ),
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
    return Align(
      alignment: AlignmentDirectional.topCenter,
      heightFactor: 0.119.h,
      child: Stack(
        alignment: const Alignment(0, 0.7),
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipPath(
                clipper: HalfCircleCurve(18.h),
                clipBehavior: Clip.antiAlias,
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: searchProductDropdownBuilder(
                            text: S.of(context).search,
                            onChanged: (product) {
                              bloc.add(SelectProductEvent(product: product!));
                              context.push(DetailsProductScreen(
                                product: product,
                                products: ConstantsManager.appUser is Customer
                                    ? bloc.products
                                    : bloc.merchantProducts,
                              ));
                            },
                            items: ConstantsManager.appUser is Customer
                                ? bloc.products
                                : bloc.merchantProducts,
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
              if (ConstantsManager.appUser is Customer) {
                context.push(const CartScreen());
              }
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
      ),
    );
  }

  Widget _buildCategoriesList(
      BuildContext context,
      MainBloc bloc,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textContainerWidget(text: S.of(context).categories),
        SizedBox(height: 1.h),
        SizedBox(
          height: 14.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => categoryWidget(
              onTap: () {
                context.push(CategoryScreen(
                  category: ConstantsManager.appUser is Customer ||
                      ConstantsManager.appUser == null
                      ? bloc.categories[index]
                      : bloc.merchantCategories[index],
                ));
              },
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
        textContainerWidget(
          text: S.of(context).merchants,
          widget: TextButton(
              onPressed: () {
                context.push(ShowAllMerchantsOrWorkers(
                  merchants: bloc.merchants,
                  workers: const [],
                ));
              },
              child: Text(S.of(context).showAll)),
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => merchantAndWorkerWidget(
            name: bloc.merchants[index].companyName,
            details: bloc.merchants[index].city,
            onTap: () => context.push(CategoryScreen(
              category: Category(
                categoryName: bloc.merchants[index].companyName,
                products: bloc.products
                    .where((product) => bloc.merchants[index].productsIds
                    .contains(product.productId))
                    .toList(),
                productsIds: bloc.merchants[index].productsIds,
              ),
            )),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemCount: bloc.merchants.length <= 3 ? bloc.merchants.length : 3,
        ),
      ],
    );
  }

  Widget _buildWorkersList(BuildContext context, MainBloc bloc) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        textContainerWidget(
          text: S.of(context).workers,
          widget: TextButton(
            onPressed: () {
              context.push(ShowAllMerchantsOrWorkers(
                merchants: const [],
                workers: bloc.workers,
              ));
            },
            child: Text(S.of(context).showAll),
          ),
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => merchantAndWorkerWidget(
            name: bloc.workers[index].name,
            details: bloc.workers[index].works.first,
            onTap: () {
              context.push(WorkerDetailsScreen(
                worker: bloc.workers[index],
              ));
            },
          ),
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemCount: bloc.workers.length <= 3 ? bloc.workers.length : 3,
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
