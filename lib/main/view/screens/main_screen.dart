import 'package:almasheed/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

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
          body: RefreshIndicator(
              onRefresh: () async {

              },
              child: bloc.pages[bloc.pageIndex]),
        );
      },
    );
  }
}
