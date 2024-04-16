import 'dart:io';

import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/chat/data/models/chat.dart';
import 'package:almasheed/chat/data/models/message.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../authentication/data/models/customer.dart';
import '../../../generated/l10n.dart';

//ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  final Chat chat;

  ChatScreen({super.key, required this.chat});

  final ScrollController listScrollController = ScrollController();
  bool isDown = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    Stream<List<Message>> messagesStream = const Stream.empty();
    ChatBloc bloc = ChatBloc.get(context)
      ..add(GetMessagesEvent(
          receiverId: chat.receiverId, isMerchant: chat.isMerchant));
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is GetMessagesSuccessState) {
          messagesStream = state.messages;
          bloc.add(
              ScrollingDownEvent(listScrollController: listScrollController));
        }
        if (state is SendMessagesSuccessState) {
          bloc.add(
              ScrollingDownEvent(listScrollController: listScrollController));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: ColorManager.primary,
              title: Text(chat.receiverName),
              actions: [
                if (ConstantsManager.appUser is! Customer && (!chat.isEnd))
                  TextButton(
                      onPressed: () {
                        chat.isEnd = true;
                        bloc.add(
                          EndChatEvent(
                            receiverId: chat.receiverId,
                            isMerchant: chat.isMerchant,
                          ),
                        );
                      },
                      child: Text(
                        S.of(context).endChat,
                        style: const TextStyle(color: ColorManager.white),
                      )),
              ]),
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
                      child: StreamBuilder<List<Message>>(
                        stream: messagesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Message> messages = snapshot.data!;
                            return ListView.separated(
                              controller: listScrollController,
                              itemBuilder: (context, index) {
                                if (messages[index].voiceNoteUrl != null) {
                                  return messageWidget(
                                    message: messages[index],
                                  );
                                }
                                return messageWidget(message: messages[index]);
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
                      ),
                    ),
                  ],
                ),
              ),
              if (bloc.imageFilePath != null || bloc.voiceNoteFilePath != null)
                Container(
                  color: ColorManager.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 0.2.h,
                        color: ColorManager.grey2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Row(
                          children: [
                            if (bloc.imageFilePath != null)
                              Image.file(
                                File(bloc.imageFilePath!),
                                height: 10.h,
                                width: 40.w,
                              ),
                            if (bloc.voiceNoteFilePath != null)
                              _voiceWidget(
                                duration: bloc.voiceNoteDuration,
                                isSender: false,
                                voice: bloc.voiceNoteFilePath!, isFile: true,
                                // isPlaying: bloc.isPlaying,
                                // playAudio: () {
                                //   bloc.add(TurnOnRecordFileEvent(
                                //     isPlaying: bloc.isPlaying,
                                //     voiceNoteUrl: bloc.voiceNoteFilePath!,
                                //   ));
                                // },
                              ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                bloc.add(RemoveRecordEvent());
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isDown)
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffCDAE8A),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.arrow_circle_down_outlined,
                          color: Colors.white),
                      onPressed: () {
                        bloc.add(ScrollingDownEvent(
                            listScrollController: listScrollController));
                      }),
                ),
              if (!chat.isEnd)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border(
                      top: BorderSide(
                        color: ColorManager.grey1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 22.sp,
                        ),
                        onTap: () {
                          bloc.add(PickImageEvent());
                        },
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.mic,
                          color: Colors.black,
                          size: 22.sp,
                        ),
                        onLongPress: () {
                          bloc.add(StartRecordingEvent());
                        },
                        onLongPressEnd: (_) {
                          bloc.add(EndRecordingEvent());
                        },
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          onChanged: (value) {
                            messageController.text = value;
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 2.w),
                            hintText: S.of(context).typeMessage,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              25.sp,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              25.sp,
                            )),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: ColorManager.primary,
                        ),
                        onPressed: () {
                          if (messageController.text != "" ||
                              bloc.voiceNoteFilePath != null ||
                              bloc.imageFilePath != null) {
                            bloc.add(RemovePickedImageEvent());
                            bloc.add(RemoveRecordEvent());
                            bloc.add(SendMessageEvent(
                              message: Message(
                                receiverName: chat.receiverName,
                                voiceNoteDuration: bloc.voiceNoteDuration,
                                createdTime: Timestamp.now(),
                                message: messageController.text,
                                imageFilePath: bloc.imageFilePath,
                                voiceNoteFilePath: bloc.voiceNoteFilePath,
                                senderId: ConstantsManager.appUser!.id,
                                receiverId: chat.receiverId,
                              ),
                              isMerchant: chat.isMerchant,
                            ));
                            messageController.clear();
                          }
                        },
                      ),
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

Widget messageWidget({required Message message}) {
  if (ConstantsManager.appUser!.id == message.senderId) {
    if (message.voiceNoteUrl != null && message.voiceNoteDuration != null) {
      return _voiceWidget(
          duration: message.voiceNoteDuration ?? 0,
          isSender: true,
          voice: message.voiceNoteUrl!,
          isFile: false);
    } else if (message.imageUrl != null) {
      return _imageWidget(image: message.imageUrl!, isSender: true);
    } else {
      return _textWidget(message: message.message ?? "", isSender: false);
    }
  } else {
    if (message.voiceNoteUrl != null && message.voiceNoteDuration != null) {
      return _voiceWidget(
          duration: message.voiceNoteDuration ?? 0,
          isSender: false,
          voice: message.voiceNoteUrl!,
          isFile: false);
    } else if (message.imageUrl != null) {
      return _imageWidget(image: message.imageUrl!, isSender: true);
    } else {
      return _textWidget(message: message.message ?? "", isSender: true);
    }
  }
}

// Widget _voiceWidget({
//   required VoidCallback playAudio,
//   required bool isPlaying,
//   required bool isSender,
// }) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 2.w),
//     child: Align(
//       alignment: !isSender
//           ? AlignmentDirectional.topStart
//           : AlignmentDirectional.topEnd,
//       child: Container(
//         decoration: BoxDecoration(
//             color: isSender ? ColorManager.primary : const Color(0xffac793d),
//             shape: BoxShape.circle),
//         padding: EdgeInsetsDirectional.all(5.sp),
//         child: IconButton(
//             onPressed: playAudio,
//             icon: Icon(
//               !isPlaying
//                   ? Icons.play_circle_rounded
//                   : Icons.pause_circle_filled_rounded,
//               color: ColorManager.white,
//               size: 25.sp,
//             )),
//       ),
//     ),
//   );
// }

Widget _voiceWidget({
  required bool isSender,
  required String voice,
  required int duration,
  required bool isFile,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Align(
        alignment: isSender
            ? AlignmentDirectional.topEnd
            : AlignmentDirectional.topStart,
        child: Directionality(
          textDirection: isSender ? TextDirection.rtl : TextDirection.ltr,
          child: VoiceMessageView(
            controller: VoiceController(
              audioSrc: voice,
              maxDuration: Duration(
                seconds: duration == 0 ? 1 : duration,
              ),
              isFile: isFile,
              onComplete: () {
                /// do something on complete
              },
              onPause: () {
                /// do something on pause
              },
              onPlaying: () {
                /// do something on playing
              },
              onError: (err) {},
            ),
            innerPadding: 10.sp,
            cornerRadius: 15.sp,
            circlesColor:
                isSender ? ColorManager.primary : const Color(0xffac793d),
            backgroundColor: ColorManager.grey1.withOpacity(0.9),
            activeSliderColor: ColorManager.primary,
          ),
        ),
      ),
    ],
  );
}

Widget _imageWidget({required bool isSender, required String image}) {
  return BubbleNormalImage(
    id: image,
    image: Image.network(image),
    isSender: isSender,
    color: isSender ? ColorManager.primary : const Color(0xffac793d),
  );
}

Widget _textWidget({
  required String message,
  required bool isSender,
}) {
  return BubbleSpecialThree(
    text: message,
    color: !isSender ? ColorManager.primary : const Color(0xffac793d),
    tail: true,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
    ),
    isSender: isSender,
  );
}
