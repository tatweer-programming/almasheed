import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/add_category_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/services/dep_injection.dart';
import '../../../generated/l10n.dart';
import '../../../payment/bloc/payment_bloc.dart';
import '../../bloc/main_bloc.dart';
import 'category_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = sl();
    return Scaffold(body: BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 20.h,
                  color: ColorManager.primary,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        S.of(context).allCategories,
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
                ),
                SizedBox(
                  height: 3.h,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: bloc.categories.map((category) {
                    return categoryVerticalWidget(
                        category: category,
                        categoryPressed: () {
                          context.push(CategoryScreen(category: category));
                        });
                  }).toList(),
                ),
              ],
            ),
          ],
        );
      },
    ));
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
