import 'package:almasheed/authentication/presentation/screens/login_screen.dart';
import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/main/view/screens/main_screen.dart';
import 'package:almasheed/payment/bloc/payment_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'authentication/bloc/auth_bloc.dart';
import 'core/local/shared_prefrences.dart';
import 'core/services/dep_injection.dart';
import 'core/services/firebase_options.dart';
import 'core/utils/theme_manager.dart';
import 'generated/l10n.dart';
import 'main/bloc/main_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ServiceLocator().init();
  await CacheHelper.init();


 //  ConstantsManager.userId = await CacheHelper.getData(key: "userId");
 //  ConstantsManager.userType = await CacheHelper.getData(key: "userType");
 //  var res = await FirebaseFirestore.instance.collection("customers").
 //  where("phone" , isEqualTo: "+966551234567").get() ;
 // print(res.docs.length);
  runApp(const Masheed());
}

class Masheed extends StatelessWidget {
  const Masheed({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
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
          child: MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: 'Al Masheed',
            locale: Locale("ar"),
            theme: getAppTheme(),
            home:  const MainScreen(),
            // home: ConstantsManager.userType != null &&
            //         ConstantsManager.userId != null
            //     ? const ChatScreen()
            //     : const LoginScreen(),
          ));
    });
  }
}
/*
POST /sms.do?access_token=%3CREQUIRED%3E HTTP/1.1
Content-Type: application/json
X-Rapidapi-Key: SIGN-UP-FOR-KEY
X-Rapidapi-Host: smsapi-com3.p.rapidapi.com
Host: smsapi-com3.p.rapidapi.com
Content-Length: 343

{
  "to": "",
  "message": "",
  "from": "",
  "normalize": "",
  "group": "",
  "encoding": "",
  "flash": "",
  "test": "",
  "details": "",
  "date": "",
  "date_validate": "",
  "time_restriction": "follow",
  "allow_duplicates": "",
  "idx": "",
  "check_idx": "",
  "max_parts": "",
  "fast": "",
  "notify_url": "",
  "format": "json"
}
 */