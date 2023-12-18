import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.secondary,
          bottomNavigationBar: ResponsiveNavigationBar(
            navigationBarButtons: [
              NavigationBarButton(
                  text: 'Home',
                  icon: Icons.home_outlined,
                  backgroundColor: ColorManager.primary,
                  textColor: ColorManager.white),
              NavigationBarButton(
                  text: 'Profile',
                  icon: Icons.person,
                  backgroundColor: ColorManager.primary,
                  textColor: ColorManager.white),
              NavigationBarButton(
                  text: 'Support',
                  icon: Icons.support,
                  backgroundColor: ColorManager.primary,
                  textColor: ColorManager.white),
            ],
            onTabChange: (index) {
              bloc.add(ChangeBottomNavEvent(index: index));
            },
            activeIconColor: ColorManager.white,
            backgroundColor: ColorManager.grey1,
            selectedIndex: bloc.pageIndex,
            padding: EdgeInsets.zero,
            inactiveIconColor: Colors.black,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10.sp),
                        ),
                        actions: [
                          TextButton(onPressed: (){
                            context.pop();
                          }, child: const Text("Cancel")),
                          TextButton(onPressed: (){
                            context.pop();
                          }, child: const Text("Okay")),
                        ],
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                                                    ],
                        )
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                bloc.add(GetOffersEvent());
                bloc.add(GetCategoriesEvent());
                bloc.add(GetBestSalesEvent());
              },
              child: bloc.pages[bloc.pageIndex]),
        );
      },
    );
  }
}
