import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/orders/add_order_to_worker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../authentication/data/models/customer.dart';
import '../../../../authentication/presentation/components.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../generated/l10n.dart';
import '../../../bloc/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
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
          floatingActionButton: ConstantsManager.appUser is Customer
              ? FloatingActionButton(
                  onPressed: () {
                    context.push(const AddOrderToWorkerScreen());
                  },
                  child: const Icon(Icons.add),
                )
              : null,
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
              if (ConstantsManager.appUser is Merchant ||
                  ConstantsManager.appUser is Customer)
                BottomNavigationBarItem(
                    label: S.of(context).categories,
                    icon: const Icon(
                      Icons.category_outlined,
                    )),
              if (ConstantsManager.appUser is Customer)
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
                if(ConstantsManager.appUser is! Worker) {
                  bloc.add(GetProductsEvent());
                }
                  bloc.add(GetWorkersEvent());
                  bloc.add(GetMerchantsEvent());
              },
              child: (ConstantsManager.appUser is Merchant)
                  ? bloc.pagesMerchant[bloc.pageIndex]
                  : (ConstantsManager.appUser is Customer)
                      ? bloc.pagesCustomer[bloc.pageIndex]
                      : bloc.pagesWorker[bloc.pageIndex]),
        );
      },
    );
  }
}
