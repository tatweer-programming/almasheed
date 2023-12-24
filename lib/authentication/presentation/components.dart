import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/presentation/screens/account_type_screen.dart';
import 'package:almasheed/authentication/presentation/screens/login_screen.dart';
import 'package:almasheed/authentication/presentation/screens/terms_and_conditions_screen.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/utils/color_manager.dart';

class AccountTypeItem extends StatelessWidget {
  final String type;
  final AuthBloc bloc ;
  final int index ;
  final IconData iconData ;

  const AccountTypeItem(
      {super.key, required this.type, required this.bloc, required this.index, required this.iconData,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bloc.add(SelectAccountTypeEvent(index: index));
      },
      child: SizedBox(
        height: 35.w,
        width: 35.w,
        child: Card(
          color: index == bloc.selectedAccountTypeIndex ? ColorManager.primary : ColorManager.white,
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon (iconData , size: 40.sp,
            color: index == bloc.selectedAccountTypeIndex ? ColorManager.white : ColorManager.black,

            ),
              SizedBox(
                height: 6.sp,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: index == bloc.selectedAccountTypeIndex ? ColorManager.white : ColorManager.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("+966",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(
          width: 5.sp,
        ),
        Expanded(
          child: defaultFormField(
              type: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter phone number';
                }
                return null;
              },
              label: "Phone Number",
              controller: controller),
        ),
      ],
    );
  }
}

Widget defaultFormField(
        {required String label,
        // IconData? prefix,
        // IconButton? suffix,
        // bool? enabled = true,
        //String? validatorText,
        TextInputType? type,
        //   void Function()? suffixFunction,
        FormFieldValidator? validator,
        // bool obscureText = false,
        required TextEditingController controller}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      cursorColor: ColorManager.primary,
      decoration: InputDecoration(
          isDense: true,
          // Added this
          contentPadding: EdgeInsets.all(15.sp),
          filled: true,
          fillColor: ColorManager.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.sp)),
          labelText: label,
          labelStyle: const TextStyle(
            color: ColorManager.black,
          )),
      validator: validator,
    );

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.primary,
    textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.error,
    textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

class TermsAgreementWidget extends StatelessWidget {
 final AuthBloc bloc ;
 final String userType ;
  const TermsAgreementWidget({super.key, required this.bloc, required this.userType});

  @override
  Widget build(BuildContext context) {
    return   Row (
      children: [
        Checkbox(
            value: bloc.agreeToTerms,
            onChanged: (value) {
              bloc.add(ChangeAgreeToTermsStateEvent(
                  state: value!));
            }),
        Text(
          "I Agree to",
          style: TextStyle(fontSize: 14.sp),
        ),
        TextButton(
            onPressed: () {
              context.push( TermsAndConditionsScreen(
                  userType: userType));
            },
            child: Text(
              "Terms & conditions",
              style: TextStyle(
                fontSize: 15.sp,
                decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }
}

class RegisterNowWidget extends StatelessWidget {
  const RegisterNowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      child: Row (
        children: [
          Text(
            "You don't have an account ?",
            style: TextStyle(fontSize: 12.sp),
          ),
          TextButton(
              onPressed: () {
                context.push( const AccountTypeScreen());
              },
              child: Text(
                "Register now",
                style: TextStyle(
                  fontSize: 13.sp,
                  decoration: TextDecoration.underline,
                ),
              ))
        ],
      ),
    );
  }
}


class LoginNowWidget extends StatelessWidget {
  const LoginNowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      child: Row (
        children: [
          Text(
            "Already have account ?",
            style: TextStyle(fontSize: 12.sp),
          ),
          TextButton(
              onPressed: () {
                context.pushAndRemove( LoginScreen());
              },
              child: Text(
                "Login now",
                style: TextStyle(
                  fontSize: 13.sp,
                  decoration: TextDecoration.underline,
                ),
              ))
        ],
      ),
    );
  }
}
