import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/addresses_screen.dart';
import 'package:almasheed/authentication/presentation/screens/faq_screen.dart';
import 'package:almasheed/authentication/presentation/screens/favourites_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/screens/home_page_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 100.w,
            child: ClipPath(
              clipper: CurveClipper1(18.h),
              child: Container(
                height: 35.h,
                color: ColorManager.primary,
                child: Padding(
                  padding:
                  EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
                  child: Column(
                    children: [
                      SizedBox(height: 5.h,),
                      Text(S.of(context).myAccount, style: TextStyle(color: ColorManager.white, fontSize: 30.sp,fontWeight: FontWeight.bold),),
                          SizedBox(width: 3.h),
                       Icon(Icons.person_outline_rounded , color: ColorManager.white, size: 40.sp,),
                          SizedBox(width: 3.h),

                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h,),
          Text(S.of(context).welcome, style: TextStyle(color: ColorManager.primary, fontSize: 30.sp,fontWeight: FontWeight.bold),),
          SizedBox(height: 3.h,),
          Padding(
            padding:  EdgeInsets.all(5.0.w),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
               children: [

                 ProfileItemBuilder(iconData: Icons.person_outline_rounded, label: S.of(context).myOrders, nextScreen: const OrdersScreen(),),
                 ProfileItemBuilder(iconData: Icons.favorite, label: S.of(context).favourites, nextScreen: const FavouritesScreen(),),
                 ProfileItemBuilder(iconData: Icons.map_outlined, label: S.of(context).addressesList, nextScreen: const AddressesScreen(),),
                 ProfileItemBuilder(iconData: Icons.question_mark_outlined, label: S.of(context).faq, nextScreen: const FAQScreen(),),

               ],
            ),
          )
        ],
      ),
    );
  }
}
