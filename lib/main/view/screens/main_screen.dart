import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/presentation/components.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../../generated/l10n.dart';
import '../../bloc/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    ConstantsManager.appUser == null && ConstantsManager.registrationSkipped == null
        ? bloc.add(GetUserDataEvent())
        : DoNothingAction();

    return BlocConsumer<MainBloc, MainState>(
      bloc: bloc,
      listener: (context, state)  {
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: bloc.pageIndex,
            selectedItemColor: ColorManager.white,
            unselectedItemColor: ColorManager.grey2,
            backgroundColor: ColorManager.primary,
            onTap: (index) {
              bloc.add(ChangeBottomNavEvent(index: index));
            },
            items: [
              BottomNavigationBarItem(
                  label: S.of(context).home,
                  icon: const Icon(
                    Icons.home_outlined,
                  )),
              BottomNavigationBarItem(
                  label: S.of(context).categories,
                  icon: const Icon(
                    Icons.category_outlined,
                  )),
              if (ConstantsManager.appUser is! Merchant)
                BottomNavigationBarItem(
                    label: S.of(context).favourites,
                    icon: const Icon(
                      Icons.favorite_outline_rounded,
                    )),
              BottomNavigationBarItem(
                  label: S.of(context).profile,
                  icon: const Icon(
                    Icons.person,
                  )),
              BottomNavigationBarItem(
                  label: S.of(context).support,
                  icon: const Icon(
                    Icons.support,
                  )),
            ],
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                bloc.add(GetProductsEvent());
                bloc.add(GetMerchantsEvent());
              },
              child: (ConstantsManager.appUser is Merchant)
                  ? bloc.pagesMerchant[bloc.pageIndex]
                  : bloc.pagesCustomer[bloc.pageIndex]),
        );
      },
    );
  }
}
