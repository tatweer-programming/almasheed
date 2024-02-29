import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/addresses_screen.dart';
import 'package:almasheed/authentication/presentation/screens/faq_screen.dart';
import 'package:almasheed/authentication/presentation/screens/login_screen.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:almasheed/payment/presentation/screens/cart_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/screens/last_seen_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc? authBloc;
    if (ConstantsManager.appUser != null) {
      authBloc = AuthBloc();
    }
    print(ConstantsManager.appUser);
    return SingleChildScrollView(
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                width: 100.w,
                child: ClipPath(
                  clipper: HalfCircleCurve(18.h),
                  child: Container(
                    height: 35.h,
                    color: ColorManager.primary,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w, top: 1.h),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            S.of(context).myAccount,
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 3.h),
                          Icon(
                            Icons.person_outline_rounded,
                            color: ColorManager.white,
                            size: 40.sp,
                          ),
                          SizedBox(width: 3.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              if (ConstantsManager.appUser != null)
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: authBloc,
                  builder: (context, state) {
                    return CircleAvatar(
                      radius: 20.w,
                      backgroundImage: NetworkImage(ConstantsManager.appUser!.image!),
                      child: Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: IconButton(
                            onPressed: () async {
                              authBloc!.add(UpdateProfilePictureEvent());
                            },
                            icon: CircleAvatar(
                              backgroundColor: ColorManager.white,
                              child: state is UpdateProfileLoadingState
                                  ? Padding(
                                      padding: EdgeInsets.all(3.0.sp),
                                      child: const CircularProgressIndicator(),
                                    )
                                  : const Icon(
                                      Icons.edit,
                                      color: ColorManager.black,
                                    ),
                            )),
                      ),
                    );
                  },
                ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ConstantsManager.appUser == null)
                    Text(
                      S.of(context).welcome,
                      style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  SizedBox(
                    width: 1.w,
                  ),
                  if (ConstantsManager.appUser != null)
                    Text(
                      ConstantsManager.appUser!.getName(),
                      style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              if (ConstantsManager.appUser != null)
                Text(
                  textDirection: TextDirection.ltr,
                  "+966 ${ConstantsManager.appUser!.phone.replaceAll("+966", "")}",
                  style: const TextStyle(
                      // color: ColorManager.primary,
                      // fontSize: 22.sp,
                      fontWeight: FontWeight.bold),
                ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.all(5.0.w),
                child: Column(
                  children: [
                    ConstantsManager.appUser is Customer
                        ? ProfileItemBuilder(
                            iconData: Icons.person_outline_rounded,
                            label: S.of(context).myOrders,
                            nextScreen: const CartScreen(),
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    if (ConstantsManager.appUser is Customer)
                      ProfileItemBuilder(
                        iconData: Icons.map_outlined,
                        label: S.of(context).addressesList,
                        nextScreen: const AddressesScreen(),
                      ),
                    if (ConstantsManager.appUser is Customer)
                      ProfileItemBuilder(
                        iconData: Icons.remove_red_eye_rounded,
                        label: S.of(context).lastSeen,
                        nextScreen: const LastSeenScreen(),
                      ),
                    ProfileItemBuilder(
                      iconData: Icons.question_mark_outlined,
                      label: S.of(context).faq,
                      nextScreen: const FAQScreen(),
                    ),
                    if (ConstantsManager.appUser == null)
                      settingItemBuilder(
                          label: S.of(context).loginNow,
                          iconData: Icons.login,
                          onTap: () async {
                            context.pushAndRemove(const LoginScreen());
                          }),
                    ConstantsManager.appUser != null
                        ? BlocConsumer<AuthBloc, AuthState>(
                            bloc: authBloc,
                            builder: (context, state) {
                              return state is LoginLoadingState
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : settingItemBuilder(
                                      label: S.of(context).logout,
                                      iconData: Icons.logout,
                                      onTap: () async {
                                        authBloc!.add(LogoutEvent());
                                      });
                            },
                            listener: _handleAuthStates,
                          )
                        : const SizedBox()
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _handleAuthStates(BuildContext context, state) {
    if (state is LogoutSuccessfulState) {
      Future.delayed(Duration.zero, () {
        context.pushAndRemove(const LoginScreen());
      });
    } else if (state is LogoutErrorState) {
      errorToast(msg: ExceptionManager(state.exception).translatedMessage());
    }
  }
}
