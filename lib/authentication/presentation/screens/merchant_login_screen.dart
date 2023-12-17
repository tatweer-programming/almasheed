import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/presentation/screens/otp_screen.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../bloc/auth_bloc.dart';
import '../components.dart';

class MerchantLoginScreen extends StatelessWidget {
  const MerchantLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey <FormState>();
    TextEditingController phoneController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController registrationNumberController = TextEditingController();
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
                  child: SingleChildScrollView(
                    child: Column(
                    
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Phone Number", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp
                        ),),
                        SizedBox(height: 5.sp,),
                        PhoneNumberInput(controller: phoneController ),
                        SizedBox(height: 10.sp,),
                        defaultFormField(label: "Company name",
                          controller: companyNameController ,
                        validator:  (value) {
                          if (value!.isEmpty) {
                            return 'please enter company Name ';
                          }
                          return null;
                        },),
                        SizedBox(height: 10.sp,),
                        defaultFormField(label: "City", controller: cityController ,
                        validator:  (value) {
                          if (value!.isEmpty) {
                            return 'please enter city name';
                          }
                          return null;
                        },
                        ),
                        SizedBox(height: 10.sp,),
                        defaultFormField(label: "Area", controller: areaController ,
                        validator:  (value) {
                          if (value!.isEmpty) {
                            return 'please enter area';
                          }
                          return null;
                        },
                        ),
                        SizedBox(height: 10.sp,),
                        defaultFormField(label:
                        "Registration number", controller: registrationNumberController,
                        validator:  (value) {
                          if (value!.isEmpty) {
                            return 'please enter registration number';
                          }
                          return null;
                        },
                        ),
                        SizedBox(height: 10.sp,),
                        state is SendCodeLoadingState ? const
                        Center(child: CircularProgressIndicator()):    Container(
                          decoration: const BoxDecoration(
                              color: ColorManager.primary,
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(10, 20))),
                          width: 25.w,
                          height: 30.sp,
                    
                          child: InkWell(
                            onTap: ()  {
                              if (formKey.currentState!.validate()&& bloc.agreeToTerms == true) {
                                Merchant merchant =
                                Merchant(companyName: companyNameController.text,
                                    city: cityController.text,
                                    area: areaController.text,
                                    registrationNumber:
                                    registrationNumberController.text,
                                    orders: [],
                                    id: "",
                                    phone: "+966${phoneController.text}");
                                bloc.add(SendCodeEvent(merchant));
                              }
                          else if (!bloc.agreeToTerms){
                            errorToast(msg: "You must agree to the terms and conditions");
                              }
                          
                            },
                            child:  const Center(child:
                            Text(" Send code " ,
                              style: TextStyle(
                                  color: ColorManager.white
                              ),
                            ),),
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
              ),
            );
          },
        );
      },
    );
  }
}
