import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import '../../../authentication/presentation/components.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../../generated/l10n.dart';
import '../../bloc/main_bloc.dart';
import 'add_product_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    ConstantsManager.appUser == null
        ? bloc.add(GetUserDataEvent())
        : DoNothingAction();
    return BlocConsumer<MainBloc, MainState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc.add(GetOffersEvent());
          bloc.add(GetCategoriesEvent());
          bloc.add(GetBestSalesEvent());
        } else if (state is GetUserDataErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: ResponsiveNavigationBar(
            navigationBarButtons: [
              NavigationBarButton(
                  text: S.of(context).home,
                  icon: Icons.home_outlined,
                  backgroundColor: ColorManager.primary,
                  textColor: ColorManager.white),
              NavigationBarButton(
                  text: S.of(context).profile,
                  icon: Icons.person,
                  backgroundColor: ColorManager.primary,
                  textColor: ColorManager.white),
              NavigationBarButton(
                  text: S.of(context).support,
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
          floatingActionButton: ConstantsManager.appUser is Merchant
              ? FloatingActionButton(
                  onPressed: () {
                    context.push(const AddProductScreen());
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          body: RefreshIndicator(
              onRefresh: () async {
                bloc.add(GetProductsEvent());
                bloc.add(GetMerchantsEvent());
              },
              child: bloc.pages[bloc.pageIndex]),
        );
      },
    );
  }
}
