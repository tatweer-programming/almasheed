import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/services/auth_services.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey <FormState>();
    TextEditingController phoneController = TextEditingController();
    AuthBloc bloc = AuthBloc.get(context);

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: bloc,
      listenWhen: (AuthState, authState){
        return (bloc.verificationId != null);
      },
      listener: (context, state) {
        if (bloc.verificationId != null) {
          context.push(const OTPScreen());
        }
      },
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          bloc: bloc,
          builder: (context, state) {

            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: EdgeInsets.all(5.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Phone Number", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp
                      ),),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("+966", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp
                          )),
                          SizedBox(width: 5.sp,),
                          Expanded(
                            child: TextFormField(

                              maxLines: 1,
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {

                                if (formKey.currentState!.validate()) {
                                  Customer customer = Customer(cartItems: [],
                                      favorites: [], orders: [], id: "", phone: "+966${phoneController.text}");
                                  bloc.add(SendCodeEvent(customer));
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius:
                                  BorderRadius.circular(10.sp))
                              ),
                              controller: phoneController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter phone number';
                                }
                                return null;
                              },
                            ),
                          )

                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: const BorderRadius.all(
                                Radius.elliptical(10, 20))),
                        width: 25.w,
                        height: 30.sp,

                        child: InkWell(
                          onTap: ()  {
                            if (formKey.currentState!.validate()) {
                              Customer customer =
                              Customer(cartItems: [], favorites: [],
                                  orders: [], id: "", phone:
                                  "+966${phoneController.text}");
                              bloc.add(SendCodeEvent(customer));
                            }
                          },
                          child: const Center(child: Text(" Send code "),),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: bloc.agreeToTerms, onChanged: (value) {
                            bloc.add(
                                ChangeAgreeToTermsStateEvent(state: value!));
                          }),
                          Text("I Agree to", style: TextStyle(
                              fontSize: 14.sp
                          ),),
                          TextButton(onPressed: () {}, child: Text(
                            "Terms & conditions", style: TextStyle(
                            fontSize: 15.sp,
                            decoration: TextDecoration.underline,
                          ),))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
