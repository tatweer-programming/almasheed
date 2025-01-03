import 'package:almasheed/chat/presentation/screens/chat_screen.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/widgets/widgets.dart';
import '../../bloc/chat_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = ChatBloc.get(context)..add(GetChatsEvent());
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.pushAndRemove(const MainScreen());
      },
      child: RefreshIndicator(
        onRefresh: () async {
          chatBloc.add(GetChatsEvent());
        },
        child: Scaffold(
          body: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                heightFactor: 0.9,
                child: ClipPath(
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
                            S.of(context).chat,
                            style: TextStyle(
                                color: ColorManager.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Icon(
                              Icons.chat_bubble,
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
              ),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    return ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => _chatsWidget(
                            text: chatBloc.chats[index].receiverName,
                            onTap: () {
                              context.push(ChatScreen(
                                chat: chatBloc.chats[index],
                              ));
                            }),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 1.h,
                            ),
                        itemCount: chatBloc.chats.length);
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _chatsWidget({required String text, required VoidCallback onTap}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: SizedBox(
          height: 7.h,
          child: Card(
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(5.sp)),
            color: ColorManager.secondary,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  Text(
                    text,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorManager.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
