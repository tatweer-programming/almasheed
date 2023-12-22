import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/utils/color_manager.dart';

class AccountTypeItem extends StatelessWidget {
  final String type;
  final Widget nextScreen;

  const AccountTypeItem(
      {super.key, required this.type, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(nextScreen);
      },
      child: SizedBox(
        height: 35.w,
        width: 35.w,
        child: Card(
          elevation: 5,
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
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
