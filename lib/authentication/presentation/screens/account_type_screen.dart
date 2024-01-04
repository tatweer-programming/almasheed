import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/assets_manager.dart';
import 'package:almasheed/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/font_manager.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen  ({super.key});

  @override
  Widget build(BuildContext context) {
  AuthBloc bloc = AuthBloc.get(context);

    return  Scaffold(
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Align(
            child: AuthBackground(imagePath: AssetsManager.building_2, child:  Column(
              children: [
                SizedBox(
                  height: 6.h,
                ),
                Text( S.of(context).welcomeToAlmasheed, style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeightManager.bold,
                  color: ColorManager.white,
                )),
                SizedBox(
                  height: 5.sp,
                ),
                Text( S.of(context).chooseAccountType, style: TextStyle(
                  fontSize: 13.sp,
                  //fontWeight: FontWeightManager.bold,
                  color: ColorManager.white,
                )),
                SizedBox(
                  height: 5.sp,
                ),
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
                                  AccountTypeItem(type: S.of(context).merchant, bloc: bloc ,iconData: Icons.store_mall_directory_outlined,index: 0, ),
                                  const Spacer(),
                                  AccountTypeItem(type: S.of(context).customer,
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
                  child: Container(
                    color: ColorManager.white,
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
                      child:  Center(
                          child: Text(
                            S.of(context).next,
                            style: const TextStyle(
                                color: ColorManager.primary,
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
            )),
          ),
        ],
      ),
    );
  }
}
