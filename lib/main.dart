import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/localization_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'authentication/bloc/auth_bloc.dart';
import 'authentication/presentation/screens/account_type_screen.dart';
import 'authentication/presentation/screens/login_screen.dart';
import 'chat/presentation/screens/chat_screen.dart';
import 'core/local/shared_prefrences.dart';
import 'core/services/dep_injection.dart';
import 'core/services/firebase_options.dart';
import 'core/utils/theme_manager.dart';
import 'generated/l10n.dart';
import 'main/bloc/main_bloc.dart';
import 'main/view/screens/main/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await CacheHelper.init();
  ServiceLocator().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await LocalizationManager.init();
  ConstantsManager.userId = await CacheHelper.getData(key: "userId");
  ConstantsManager.isNotificationsOn =
      await CacheHelper.getData(key: "isNotificationsOn");
  ConstantsManager.userType = await CacheHelper.getData(key: "userType");
  print("${ConstantsManager.userId}  ${ConstantsManager.userType}");
  runApp(const Masheed());
}

class Masheed extends StatelessWidget {
  const Masheed({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   context.push(ChatScreen(
    //       isEnd: false,
    //       receiverId: message.from!.substring(8),
    //       receiverName: message.notification!.title!));
    // });
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
          providers: [
            BlocProvider<MainBloc>(
                create: (BuildContext context) => sl()
                  ..add(GetProductsEvent())
                  ..add(GetWorkersEvent())
                  ..add(GetBannersEvent())
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
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              return MaterialApp(
                // navigatorKey: navigatorKey,
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
                // home: SplashScreen(
                //   nextScreen: (ConstantsManager.userType != null &&
                //           ConstantsManager.userId != null)
                //       ? const MainScreen()
                //       : const LoginScreen(),
                home: (ConstantsManager.userType != null &&
                        ConstantsManager.userId != null)
                    ? const MainScreen()
                    : const AccountTypeScreen(),
              );
            },
          ));
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  print("Handling a background message: ${message.data}");
}
