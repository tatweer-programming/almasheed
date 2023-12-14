import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/merchant_login_screen.dart';
import 'package:almasheed/authentication/presentation/screens/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen  ({super.key});

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      body: Center(
   child:     Padding(
     padding:  EdgeInsets.all(10.w),
     child: const Row(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         AccountTypeItem(type: "Merchant", nextScreen: MerchantLoginScreen()),
         Spacer(),
         AccountTypeItem(type: "Customer",
             nextScreen: CustomerLoginScreen())

       ],
     ),
   )
      ),
    );
  }
}
