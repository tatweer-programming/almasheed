import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/authentication/presentation/screens/faq_screen.dart';
import 'package:almasheed/authentication/presentation/screens/terms_and_conditions_screen.dart';
import 'package:almasheed/core/local/shared_prefrences.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../chat/presentation/screens/chats_screen.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../bloc/main_bloc.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    bool isOn = ConstantsManager.isNotificationsOn ?? false;
    String? userType;
    final appUser = ConstantsManager.appUser;
    if (appUser != null) {
      userType = appUser.getType();
    }
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) async {
        if (state is ChangeSwitchNotificationsState) {
          isOn = state.isOn;
          print(ConstantsManager.isNotificationsOn);
          ConstantsManager.isNotificationsOn = isOn;
          await CacheHelper.saveData(key: "isNotificationsOn", value: isOn)
              .then((value) async {
            if (ConstantsManager.isNotificationsOn != null &&
                !ConstantsManager.isNotificationsOn!) {
              defaultToast(msg: S.of(context).notificationsAreTurnedOff);
              await FirebaseMessaging.instance
                  .unsubscribeFromTopic(ConstantsManager.appUser!.id);
            } else {
              defaultToast(msg: S.of(context).notificationsAreTurnedOn);
              await FirebaseMessaging.instance
                  .subscribeToTopic(ConstantsManager.appUser!.id);
            }
          });
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: HalfCircleCurve(18.h),
                child: Container(
                  height: 35.h,
                  width: double.infinity,
                  color: ColorManager.primary,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 8.w, end: 8.w, top: 1.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          S.of(context).support,
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Icon(
                            Icons.support,
                            color: ColorManager.white,
                            size: 40.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).aboutApp,
                      style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsetsDirectional.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ProfileItemBuilder(
                          iconData: Icons.design_services_sharp,
                          label: S.of(context).services,
                          nextScreen: const FAQScreen(),
                        ),
                        ProfileItemBuilder(
                          iconData: Icons.policy,
                          label: S.of(context).termsAndConditions,
                          nextScreen: TermsAndConditionsScreen(
                              userType: userType ?? "customer"),
                        ),
                        ProfileItemBuilder(
                          iconData: Icons.people,
                          label: S.of(context).whoAreWe,
                          nextScreen: const FAQScreen(),
                        ),
                        ProfileItemBuilder(
                          iconData: Icons.contact_phone_outlined,
                          label: S.of(context).contactUs,
                          nextScreen: const FAQScreen(),
                        ),
                        ProfileItemBuilder(
                          iconData: Icons.chat_bubble,
                          label: S.of(context).chat,
                          nextScreen: const ChatsScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).setting,
                      style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsetsDirectional.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        settingItemBuilder(
                          label: S.of(context).language,
                          iconData: Icons.translate,
                          suffixWidget: Row(
                            children: [
                              _textContainerLang(
                                  text: "AR",
                                  onTap: () {
                                    bloc.add(const ChangeLocaleEvent(0));
                                  }),
                              SizedBox(
                                width: 2.w,
                              ),
                              _textContainerLang(
                                  text: "ENG",
                                  onTap: () {
                                    bloc.add(const ChangeLocaleEvent(1));
                                  }),
                            ],
                          ),
                        ),
                        settingItemBuilder(
                          label: S.of(context).notifications,
                          iconData: Icons.notifications_active,
                          suffixWidget: Switch(
                            activeColor: ColorManager.secondary,
                            inactiveThumbColor: ColorManager.secondary,
                            inactiveTrackColor: ColorManager.grey2,
                            activeTrackColor: ColorManager.grey2,
                            value: isOn,
                            onChanged: (isOn) {
                              bloc.add(ChangeSwitchNotificationsEvent(isOn));
                            },
                          ),
                        ),
                        settingItemBuilder(
                            label: S.of(context).shareApp,
                            iconData: Icons.share,
                            onTap: () {
                              Share.share(
                                  'hey! check out this new app https:https://play.google.com/store/apps/details?id=com.learn.be_well',
                                  subject: 'Look what I made!');
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _textContainerLang({
  required String text,
  required VoidCallback onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 3.w, vertical: 0.5.h),
        child: Text(
          text,
          style: TextStyle(
              color: ColorManager.primary,
              fontSize: 8.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
