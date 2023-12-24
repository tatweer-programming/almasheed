import 'package:almasheed/chat/bloc/chat_bloc.dart';
import 'package:almasheed/chat/data/models/message.dart';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
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
    Map<String, bool> isPlayingMap = {};
    print(isPlayingMap);
    Stream<List<Message>> messagesStream = const Stream.empty();
    ChatBloc bloc = ChatBloc.get(context)
      ..add(const GetMessagesEvent(receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2"));
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is GetMessagesSuccessState) {
          messagesStream = state.messages;
        }
        if (state is PlayRecordState) {
          isPlayingMap[state.voiceNoteUrl] = state.isPlaying;
        }
        if (state is CompleteRecordState) {
          isPlayingMap[state.voiceNoteUrl] = state.isPlaying;
        }
      },
      builder: (context, state) {
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
                                      onSeekChanged: (value) {},
                                      playAudio: () {
                                        bloc.add(TurnOnRecordEvent(
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
                      bloc.add(PickImageEvent());
                      bloc.add(SendMessageEvent(
                        message: Message(
                          createdTime: Timestamp.now(),
                          imageFilePath: bloc.imageFilePath,
                          senderId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                          receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                        ),
                      ));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: GestureDetector(
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
                        bloc.add(SendMessageEvent(
                          message: Message(
                            createdTime: Timestamp.now(),
                            voiceNoteFilePath: bloc.voiceNoteFilePath!,
                            senderId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                            receiverId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
                          ),
                        ));
                      },
                    ),
                  ),
                ],
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
    void Function(double)? onSeekChanged,
    bool? isPlaying,
    double? position}) {
  if (ConstantsManager.appUser!.id == message.senderId) {
    if (message.voiceNoteUrl != null &&
        playAudio != null &&
        onSeekChanged != null) {
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
            color: !isSender ? ColorManager.primary : const Color(0xff7A470B),
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
    color: !isSender ? ColorManager.primary : const Color(0xff7A470B),
  );
}

Widget _textWidget({
  required String message,
  required bool isSender,
}) {
  return BubbleSpecialThree(
    text: message,
    color: !isSender ? ColorManager.primary : const Color(0xff7A470B),
    tail: true,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
    ),
    isSender: isSender,
  );
}
