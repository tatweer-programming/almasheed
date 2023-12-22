// import 'package:almasheed/chat/bloc/chat_bloc.dart';
// import 'package:almasheed/chat/data/models/message.dart';
// import 'package:almasheed/core/utils/color_manager.dart';
// import 'package:almasheed/core/utils/constance_manager.dart';
// import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
// import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
// import 'package:chat_bubbles/message_bars/message_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sizer/sizer.dart';
//
// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<Message> messages = [];
//     ChatBloc bloc = ChatBloc.get(context)..add(GetMessagesEvent(receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2"));
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 1.h,
//                 ),
//                 Expanded(
//                   child: BlocConsumer<ChatBloc, ChatState>(
//                     listener: (context, state) {
//                       if (state is GetMessagesSuccess) {
//                         messages = state.messages;
//                         print(messages);
//                       }
//                     },
//                     builder: (context, state) {
//                       return ListView.separated(
//                           itemBuilder: (context, index) {
//                             if (ConstantsManager.appUser!.id ==
//                                 messages[index].senderId) {
//                               return BubbleSpecialThree(
//                                 text: messages[index].message,
//                                 color: ColorManager.primary,
//                                 tail: true,
//                                 textStyle: TextStyle(
//                                     color: Colors.white, fontSize: 14.sp),
//                                 isSender: false,
//                               );
//                             }
//                             return BubbleSpecialThree(
//                               text: messages[index].message,
//                               color: const Color(0xff7A470B),
//                               tail: true,
//                               textStyle: TextStyle(
//                                   color: Colors.white, fontSize: 14.sp),
//                               isSender: true,
//                             );
//                           },
//                           separatorBuilder: (context, index) => SizedBox(
//                             height: 1.h,
//                           ),
//                           itemCount: messages.length);
//                     },
//                   ),
//                 )
//                 // BubbleNormalAudio(
//                 //   color: const Color(0xFFE8E8EE),
//                 //   duration: duration.inSeconds.toDouble(),
//                 //   position: position.inSeconds.toDouble(),
//                 //   isPlaying: isPlaying,
//                 //   isLoading: isLoading,
//                 //   isPause: isPause,
//                 //   onSeekChanged: (value) {
//                 //     print(value);
//                 //   },
//                 //   onPlayPauseButtonClick: () {
//                 //
//                 //   },
//                 //   sent: true,
//                 // ),
//               ],
//             ),
//           ),
//           MessageBar(
//             onSend: (message) {
//               bloc.add(SendMessageEvent(
//                   message: Message(
//                       createdTime: Timestamp.now(),
//                       message: message,
//                       senderId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
//                       receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2")));
//             },
//             sendButtonColor: ColorManager.primary,
//             actions: [
//               InkWell(
//                 child: Icon(
//                   Icons.add,
//                   color: Colors.black,
//                   size: 20.sp,
//                 ),
//                 onTap: () {},
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 1.w),
//                 child: InkWell(
//                   child: Icon(
//                     Icons.camera_alt,
//                     color: Colors.black,
//                     size: 20.sp,
//                   ),
//                   onTap: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:almasheed/chat/data/models/message.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [];
    var bloc = BlocProvider.of<ChatCubit>(context)
      ..getMessages(receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2");
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
                  child: BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is GetMessagesSuccess) {
                        messages = state.messages;
                      }
                    },
                    builder: (context, state) {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            if (ConstantsManager.appUser!.id ==
                                messages[index].senderId) {
                              return BubbleSpecialThree(
                                text: messages[index].message,
                                color: ColorManager.primary,
                                tail: true,
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                                isSender: false,
                              );
                            }
                            return BubbleSpecialThree(
                              text: messages[index].message,
                              color: const Color(0xff7A470B),
                              tail: true,
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 14.sp),
                              isSender: true,
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 1.h,
                              ),
                          itemCount: messages.length);
                    },
                  ),
                )
                // BubbleNormalAudio(
                //   color: const Color(0xFFE8E8EE),
                //   duration: duration.inSeconds.toDouble(),
                //   position: position.inSeconds.toDouble(),
                //   isPlaying: isPlaying,
                //   isLoading: isLoading,
                //   isPause: isPause,
                //   onSeekChanged: (value) {
                //     print(value);
                //   },
                //   onPlayPauseButtonClick: () {
                //
                //   },
                //   sent: true,
                // ),
              ],
            ),
          ),
          MessageBar(
            onSend: (message) {
              bloc.sendMessage(
                  message: Message(
                      createdTime: Timestamp.now(),
                      message: message,
                      senderId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                      receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2"));
            },
            sendButtonColor: ColorManager.primary,
            actions: [
              InkWell(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 20.sp,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
