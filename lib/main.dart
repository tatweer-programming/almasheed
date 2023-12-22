import 'package:almasheed/authentication/presentation/screens/account_type_screen.dart';
import 'package:almasheed/main/view/screens/main_screen.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'authentication/bloc/auth_bloc.dart';
import 'core/local/shared_prefrences.dart';
import 'core/services/dep_injection.dart';
import 'core/services/firebase_options.dart';
import 'core/utils/theme_manager.dart';
import 'main/bloc/main_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  ServiceLocator().init();
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
          BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
          BlocProvider<PaymentBloc>(
              create: (BuildContext context) => PaymentBloc())
        ],
        child: MaterialApp(
            title: 'Al Masheed', theme: getAppTheme(), home: MainScreen()),
      );
    });
  }
}
