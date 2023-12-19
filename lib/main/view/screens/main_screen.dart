import 'dart:io';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'dart:developer';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';
import 'add_product_screen.dart';

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
          floatingActionButton: ConstantsManager.appUser is! Merchant
              ? FloatingActionButton(
            onPressed: () async {
              PaymentResponse response = await MyFatoorah.startPayment(
                afterPaymentBehaviour:
                AfterPaymentBehaviour.AfterCallbackExecution,
                context: context,
                request: MyfatoorahRequest.test(

                  initiatePaymentUrl: "https://sa.myfatoorah.com/",
                  currencyIso: Country.SaudiArabia,
                  successUrl: "https://www.google.com",
                  errorUrl: "https://www.youtube.com/",
                  invoiceAmount: 100,
                  language: ApiLanguage.Arabic,
                  token:
                  "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
                ),
              );
              print(response.status.name);
              // context.push(const AddProductScreen());
            },
            child: const Icon(Icons.add),
          )
              : null,
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
