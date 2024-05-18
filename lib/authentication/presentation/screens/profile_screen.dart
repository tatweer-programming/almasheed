import 'package:almasheed/authentication/bloc/auth_bloc.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/account_type_screen.dart';
import 'package:almasheed/authentication/presentation/screens/addresses_screen.dart';
import 'package:almasheed/authentication/presentation/screens/faq_screen.dart';
import 'package:almasheed/core/error/remote_error.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/view/screens/orders/orders_for_workers_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:almasheed/payment/presentation/screens/cart_screen.dart';
import 'package:almasheed/payment/presentation/screens/myorders_for_workers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/screens/products/last_seen_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc? authBloc;
    MainBloc mainBloc = sl();
    if (ConstantsManager.appUser != null) {
      authBloc = AuthBloc();
    }
    return SingleChildScrollView(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ShowDialogState) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: state is DeleteAccountSuccessfulState
                      ? const Center(child: CircularProgressIndicator())
                      : Text(S.of(context).doWannaDeleteAccount),
                  actions: [
                    TextButton(
                        onPressed: () {
                          authBloc!.add(
                              DeleteAccountEvent(context, mainBloc.products));
                        },
                        child: Text(S.of(context).yes)),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).no)),
                  ],
                );
              },
            );
          }
          if (state is DeleteAccountSuccessfulState) {
            context.pop();
            context.pushAndRemove(const AccountTypeScreen());
          } else if (state is DeleteAccountErrorState) {
            context.pop();
            errorToast(
                msg: ExceptionManager(state.exception).translatedMessage());
          }
        },
        bloc: authBloc,
        builder: (context, state) {
          return Column(
            children: [
              appBarWidget(
                  S.of(context).myAccount, Icons.person_outline_rounded),
              SizedBox(
                height: 3.h,
              ),
              if (ConstantsManager.appUser != null)
                CircleAvatar(
                  radius: 20.w,
                  backgroundImage: ConstantsManager.appUser!.image != null
                      ? NetworkImage(ConstantsManager.appUser!.image!)
                      : null,
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
                    if (ConstantsManager.appUser is Customer)
                      ProfileItemBuilder(
                        iconData: Icons.shopping_cart,
                        label: S.of(context).cart,
                        nextScreen: const CartScreen(),
                      ),
                    if (ConstantsManager.appUser is Customer)
                      ProfileItemBuilder(
                        iconData: Icons.map_outlined,
                        label: S.of(context).addressesList,
                        nextScreen: const AddressesScreen(),
                      ),
                    if (ConstantsManager.appUser is Worker)
                      ProfileItemBuilder(
                        iconData: Icons.person,
                        label: S.of(context).editProfile,
                        nextScreen: const EditProfileScreen(),
                      ),
                    if (ConstantsManager.appUser is Worker)
                      ProfileItemBuilder(
                        iconData: Icons.map_outlined,
                        label: S.of(context).orders,
                        nextScreen: const OrdersForWorkersScreen(),
                      ),
                    if (ConstantsManager.appUser is Customer)
                      ProfileItemBuilder(
                        iconData: Icons.remove_red_eye_rounded,
                        label: S.of(context).lastSeen,
                        nextScreen: const LastSeenScreen(),
                      ),
                    if (ConstantsManager.appUser is Customer)
                      ProfileItemBuilder(
                        iconData: Icons.map_outlined,
                        label: S.of(context).myOrders,
                        nextScreen: const MyOrdersForWorkersScreen(),
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
                            context.pushAndRemove(const AccountTypeScreen());
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
                                        authBloc!.add(LogoutEvent(context));
                                        mainBloc.pageIndex = 0;
                                        context.pushAndRemove(
                                            const AccountTypeScreen());
                                      });
                            },
                            listener: (context, state) {
                              if (state is LogoutSuccessfulState) {
                                context
                                    .pushAndRemove(const AccountTypeScreen());
                              } else if (state is LogoutErrorState) {
                                errorToast(
                                    msg: ExceptionManager(state.exception)
                                        .translatedMessage());
                              }
                            },
                          )
                        : const SizedBox(),
                    if (ConstantsManager.appUser != null)
                      settingItemBuilder(
                        iconData: Icons.delete,
                        label: S.of(context).deleteAccount,
                        onTap: () {
                          authBloc!.add(ShowDialogEvent());
                        },
                      )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
