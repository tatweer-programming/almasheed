import 'dart:io';

import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/chat/data/models/message.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../generated/l10n.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;

  const ChatScreen({super.key, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    Map<String, bool> isPlayingMap = {};
    TextEditingController messageController = TextEditingController();
    Stream<List<Message>> messagesStream = const Stream.empty();
    ChatBloc bloc = ChatBloc.get(context)
      ..add(GetMessagesEvent(receiverId: receiverId));
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        print(bloc.isPlaying);
        if (state is GetMessagesSuccessState) {
          messagesStream = state.messages;
        }
        if (state is PlayRecordUrlState) {
          isPlayingMap[state.voiceNoteUrl] = state.isPlaying;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
          ),
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
                              itemBuilder: (context, index) {
                                if (messages[index].voiceNoteUrl != null) {
                                  return messageWidget(
                                      message: messages[index],
                                      isPlaying: isPlayingMap[
                                              messages[index].voiceNoteUrl] ??
                                          false,
                                      position: bloc.voiceDuration,
                                      playAudio: () {
                                        bloc.add(TurnOnRecordUrlEvent(
                                            isPlaying: isPlayingMap[
                                                    messages[index]
                                                        .voiceNoteUrl] ??
                                                false,
                                            voiceNoteUrl:
                                                messages[index].voiceNoteUrl!));
                                      });
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
                                isSender: false,
                                isPlaying: bloc.isPlaying,
                                playAudio: () {
                                  bloc.add(TurnOnRecordFileEvent(
                                    isPlaying: bloc.isPlaying,
                                    voiceNoteUrl: bloc.voiceNoteFilePath!,
                                  ));
                                },
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
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
                              createdTime: Timestamp.now(),
                              message: messageController.text,
                              imageFilePath: bloc.imageFilePath,
                              voiceNoteFilePath: bloc.voiceNoteFilePath,
                              senderId: ConstantsManager.appUser!.id,
                              receiverId: receiverId,
                            ),
                          ));
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

Widget messageWidget(
    {required Message message,
    void Function()? playAudio,
    bool? isPlaying,
    double? position}) {
  if (ConstantsManager.appUser!.id == message.senderId) {
    if (message.voiceNoteUrl != null && playAudio != null) {
      return _voiceWidget(
          isSender: false, playAudio: playAudio, isPlaying: isPlaying!);
    } else if (message.imageUrl != null) {
      return _imageWidget(image: message.imageUrl!, isSender: false);
    } else {
      return _textWidget(message: message.message ?? "", isSender: false);
    }
  } else {
    if (message.voiceNoteUrl != null && playAudio != null) {
      return _voiceWidget(
          isSender: true, playAudio: playAudio, isPlaying: isPlaying!);
    } else if (message.imageUrl != null) {
      return _imageWidget(image: message.imageUrl!, isSender: true);
    } else {
      return _textWidget(message: message.message ?? "", isSender: true);
    }
  }
}

Widget _voiceWidget({
  required VoidCallback playAudio,
  required bool isPlaying,
  required bool isSender,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 2.w),
    child: Align(
      alignment: !isSender
          ? AlignmentDirectional.topStart
          : AlignmentDirectional.topEnd,
      child: Container(
        decoration: BoxDecoration(
            color: isSender ? ColorManager.primary : const Color(0xffac793d),
            shape: BoxShape.circle),
        padding: EdgeInsetsDirectional.all(5.sp),
        child: IconButton(
            onPressed: playAudio,
            icon: Icon(
              !isPlaying
                  ? Icons.play_circle_rounded
                  : Icons.pause_circle_filled_rounded,
              color: ColorManager.white,
              size: 25.sp,
            )),
      ),
    ),
  );
}

Widget _imageWidget({required bool isSender, required String image}) {
  return BubbleNormalImage(
    id: image,
    image: Image.network(image),
    isSender: isSender,
    color: !isSender ? ColorManager.primary : const Color(0xffac793d),
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
