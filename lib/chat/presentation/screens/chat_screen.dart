import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/chat/data/models/message.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Stream<List<Message>> messagesStream = const Stream.empty();
    ChatBloc bloc = ChatBloc.get(context)
      ..add(const GetMessagesEvent(receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2"));
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listener: (context, state) {
                      if (state is GetMessagesSuccessState) {
                        messagesStream = state.messages;
                      }
                    },
                    builder: (context, state) {
                      return StreamBuilder<List<Message>>(
                        stream: messagesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Message> messages = snapshot.data!;
                            return ListView.separated(
                              itemBuilder: (context, index) {
                                if (ConstantsManager.appUser!.id ==
                                    messages[index].senderId) {
                                  return BubbleSpecialThree(
                                    text: messages[index].message,
                                    color: ColorManager.primary,
                                    tail: true,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                    isSender: false,
                                  );
                                }
                                return BubbleSpecialThree(
                                  text: messages[index].message,
                                  color: const Color(0xff7A470B),
                                  tail: true,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                  isSender: true,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 1.h,
                              ),
                              itemCount: messages.length,
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          MessageBar(
            onSend: (message) {
              bloc.add(SendMessageEvent(
                message: Message(
                  createdTime: Timestamp.now(),
                  message: message,
                  senderId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                  receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                ),
              ));
            },
            messageBarHitText: bloc.statusText,
            sendButtonColor: ColorManager.primary,
            actions: [
              InkWell(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 22.sp,
                ),
                onTap: () {
                  bloc.add(const EndRecordEvent());
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: InkWell(
                  child: Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 22.sp,
                  ),
                  onTap: () {
                    bloc.add(const StartRecordEvent());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
