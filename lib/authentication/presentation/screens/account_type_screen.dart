import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/merchant_login_screen.dart';
import 'package:almasheed/authentication/presentation/screens/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen  ({super.key});

  @override
  Widget build(BuildContext context) {
  AuthBloc bloc = AuthBloc.get(context);

    return  Scaffold(
      appBar: AppBar(
        title: const Text("Choose account type"),
     centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
               child:     Padding(
                 padding:  EdgeInsets.all(10.w),
                 child: BlocBuilder(
             bloc: bloc,
             builder: (context , state) {
               return  Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   AccountTypeItem(type: "Merchant", bloc: bloc ,iconData: Icons.store_mall_directory_outlined,index: 0, ),
                   const Spacer(),
                   AccountTypeItem(type: "Customer",
                     bloc: bloc ,iconData: Icons.person_outlined,index: 1, ),


                 ],
               );
             }
                 ),
               )
            ),
          ),
          Container (
            margin: const EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 30),
            decoration: BoxDecoration(
              color: ColorManager.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ButtonTheme(
              height: 50,
              child: TextButton(
                onPressed: () {
                if (bloc.selectedAccountTypeIndex != null){
                  bloc.add(NavigateToRegisterScreenEvent(context));
                }
                else {
                  errorToast(msg: "Please choose account type");
                }
                },
                child: const Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          Padding(padding: EdgeInsets.only(
            bottom: 20.sp ,

          ) ,
            child: const LoginNowWidget(),
          )
        ],
      ),
    );
  }
}
