import 'package:almasheed/authentication/presentation/screens/login_screen.dart';
import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/localization_manager.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:almasheed/payment/presentation/screens/merchant_orders_screen.dart';
import 'package:almasheed/payment/presentation/screens/order_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'authentication/bloc/auth_bloc.dart';
import 'authentication/presentation/screens/account_type_screen.dart';
import 'chat/presentation/screens/chat_screen.dart';
import 'core/local/shared_prefrences.dart';
import 'core/services/dep_injection.dart';
import 'core/services/firebase_options.dart';
import 'core/utils/theme_manager.dart';
import 'generated/l10n.dart';
import 'main/bloc/main_bloc.dart';
import 'main/data/models/custom_properties.dart';
import 'main/view/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  ServiceLocator().init();
  await LocalizationManager.init();
  ConstantsManager.userId = await CacheHelper.getData(key: "userId");
  ConstantsManager.isNotificationsOn =
      await CacheHelper.getData(key: "isNotificationsOn");
  ConstantsManager.userType = await CacheHelper.getData(key: "userType");
  print(DateTime.now());
  PorductCustomProperties properties = PorductCustomProperties(
    properties: {
      'color': ['red', 'blue', 'green'],
      'size': ['small', 'medium', 'large'],
      'weight': ['1kg', '2kg', '3kg']
    },
    availableProperties: [
      'red-small-1kg',
      'red-small-2kg',
      'red-small-3kg',
      'red-medium-1kg',
      'red-medium-2kg',
      'green-small-2kg'
    ],
  );
  print(properties.searchinAvailablePropsfromChoosenProps(['green', '1kg']));
  runApp(const Masheed());
}

class Masheed extends StatelessWidget {
  const Masheed({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
          providers: [
            BlocProvider<MainBloc>(
                create: (BuildContext context) => sl()
                  ..add(GetProductsEvent())
                  ..add(GetMerchantsEvent())),
            BlocProvider<AuthBloc>(
                create: (BuildContext context) => AuthBloc()),
            BlocProvider<PaymentBloc>(
                create: (BuildContext context) => PaymentBloc()),
            BlocProvider<ChatBloc>(
                create: (BuildContext context) => ChatBloc(ChatInitial()))
          ],
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                title: 'Al Masheed',
                locale: LocalizationManager.getCurrentLocale(),
                theme: getAppTheme(),
                home: const MainScreen(),
                // home: ConstantsManager.userType != null &&
                //         ConstantsManager.userId != null
                //     ? const MainScreen()
                //     : const LoginScreen(),
              );
            },
          ));
    });
  }
}
