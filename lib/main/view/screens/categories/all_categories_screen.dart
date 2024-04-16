import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../generated/l10n.dart';
import '../../../bloc/main_bloc.dart';
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
                  children: bloc.merchantCategories.map((category) {
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
