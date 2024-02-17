import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/presentation/screens/account_type_screen.dart';
import 'package:almasheed/authentication/presentation/screens/login_screen.dart';
import 'package:almasheed/authentication/presentation/screens/terms_and_conditions_screen.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import '../../core/utils/color_manager.dart';
import '../../generated/l10n.dart';
import '../data/models/address.dart';

class AccountTypeItem extends StatelessWidget {
  final String type;
  final AuthBloc bloc;

  final int index;

  final IconData iconData;

  const AccountTypeItem({
    super.key,
    required this.type,
    required this.bloc,
    required this.index,
    required this.iconData,
  });

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
          color:
              index == bloc.selectedAccountTypeIndex ? ColorManager.secondary : ColorManager.white,
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40.sp,
                color: ColorManager.black,
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
                        color: ColorManager.black,
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
        SizedBox(
          width: 5.sp,
        ),
        Expanded(
          child: defaultFormField(
              prefixIcon: SizedBox(
                width: 50.sp,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child:
                      Text(" +966", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                ),
              ),
              type: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return S.of(context).enterPhone;
                }
                return null;
              },
              label: S.of(context).phoneNumber,
              controller: controller),
        ),
      ],
    );
  }
}

Widget defaultFormField(
        {required String label,
        void Function(String?)? onSubmit,
        // IconData? prefix,
        // IconButton? suffix,
        // bool? enabled = true,
        //String? validatorText,
        TextInputType? type,
        Widget? prefixIcon,
        //   void Function()? suffixFunction,
        FormFieldValidator? validator,
        // bool obscureText = false,
        required TextEditingController controller}) =>
    SizedBox(
      height: 7.h,
      child: TextFormField(
        onFieldSubmitted: onSubmit,
        controller: controller,
        keyboardType: type,
        cursorColor: ColorManager.primary,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.sp)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.sp)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.sp)),
            isDense: true,
            errorStyle: const TextStyle(color: ColorManager.white),
            prefixIcon: prefixIcon,

            // Added this
            contentPadding: EdgeInsets.all(15.sp),
            filled: true,
            fillColor: ColorManager.secondary,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.sp)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.sp)),
            labelText: label,
            labelStyle: const TextStyle(
              color: ColorManager.black,
            )),
        validator: validator,
      ),
    );

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.green,
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
  final AuthBloc bloc;

  final String userType;

  const TermsAgreementWidget({super.key, required this.bloc, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            activeColor: ColorManager.white,
            checkColor: ColorManager.black,
            focusColor: ColorManager.white,
            value: bloc.agreeToTerms,
            onChanged: (value) {
              bloc.add(ChangeAgreeToTermsStateEvent(state: value!));
            }),
        Text(
          S.of(context).agreeTo,
          style: TextStyle(fontSize: 14.sp, color: ColorManager.white),
        ),
        TextButton(
            onPressed: () {
              context.push(TermsAndConditionsScreen(
                userType: userType,
              ));
            },
            child: Text(
              S.of(context).termsAndConditions,
              style: TextStyle(
                color: ColorManager.white,
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
    return FittedBox(
      child: Row(
        children: [
          Text(
            S.of(context).doNotHaveAccount,
            style: TextStyle(fontSize: 12.sp, color: ColorManager.white),
          ),
          TextButton(
              onPressed: () {
                context.push(const AccountTypeScreen());
              },
              child: Text(
                S.of(context).registerNow,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorManager.white,
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
    return FittedBox(
      child: Row(
        children: [
          Text(
            S.of(context).alreadyHaveAccount,
            style: TextStyle(fontSize: 12.sp, color: ColorManager.white),
          ),
          TextButton(
              onPressed: () {
                context.pushAndRemove(const LoginScreen());
              },
              child: Text(
                S.of(context).loginNow,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorManager.white,
                  decoration: TextDecoration.underline,
                ),
              ))
        ],
      ),
    );
  }
}

class AuthBackground extends StatelessWidget {
  final String imagePath;

  final Widget child;

  const AuthBackground({super.key, required this.imagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      alignment: AlignmentDirectional.bottomCenter,
      decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage(imagePath , ) , opacity: 10),
          color: ColorManager.primary,
          borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(120.sp))),
      child: Stack(
        children: [
          Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Opacity(
                  opacity: .35,
                  child: Image(
                    image: AssetImage(
                      imagePath,
                    ),
                  ))),
          child
        ],
      ),
    );
  }
}

class ProfileItemBuilder extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Widget nextScreen;
  final void Function()? onPressed;
  const ProfileItemBuilder(
      {super.key,
      required this.label,
      required this.iconData,
      required this.nextScreen,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 7.h,
        width: 90.w,
        child: InkWell(
          onTap: onPressed ??
              () {
                context.push(nextScreen);
              },
          child: Card(
            elevation: 5,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.sp),
              borderSide: BorderSide.none,
            ),
            color: ColorManager.primary,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  Icon(
                    iconData,
                    color: ColorManager.white,
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorManager.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorManager.white,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class AddressBuilder extends StatelessWidget {
  final Address address;
  const AddressBuilder({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: Card(
        elevation: 5,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.sp),
          borderSide: BorderSide.none,
        ),
        color: ColorManager.secondary,
        child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AddressItem(label: S.of(context).addressType, value: address.type),
                          SizedBox(
                            height: 1.h,
                          ),
                          AddressItem(label: S.of(context).city, value: address.city),
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          AddressItem(label: S.of(context).street, value: address.street),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        AddressItem(
                            label: S.of(context).houseNumber,
                            value: address.houseNumber.toString()),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(label: S.of(context).floor, value: address.floor.toString()),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).apartmentNumber,
                            value: address.apartmentNumber.toString()),
                      ],
                    ))
                  ],
                ))
              ],
            )),
      ),
    );
  }
}

class AddressItem extends StatelessWidget {
  final String label;
  final String value;

  const AddressItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 12.sp,
            color: ColorManager.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 5.sp,
        ),
        Expanded(
            child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            overflow: TextOverflow.visible,
            fontSize: 13.sp,
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    ));
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(S.of(context).loginFirst),
        SizedBox(
          height: 10.sp,
        ),
        MaterialButton(
          color: ColorManager.primary,
          onPressed: () {
            context.pushAndRemove(const LoginScreen());
          },
          child: Text(
            S.of(context).loginNow,
            style: const TextStyle(color: ColorManager.white),
          ),
        )
      ],
    );
  }
}

class AuthenticationWidget extends StatelessWidget {
  final Widget child;
  const AuthenticationWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (ConstantsManager.appUser != null) {
      return child;
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: const Center(child: LoginWidget()),
      );
    }
  }
}
