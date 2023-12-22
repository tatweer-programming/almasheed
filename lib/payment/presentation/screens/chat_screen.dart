import 'package:almasheed/core/utils/color_manager.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration();
    Duration position = const Duration();
    bool isPlaying = false;
    bool isLoading = false;
    bool isPause = false;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 2.h,),
                BubbleSpecialThree(
                  text: 'Please try and give some feedback on it!',
                  color: ColorManager.primary,
                  tail: true,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp
                  ),
                ),
                BubbleNormalAudio(
                  color: const Color(0xFFE8E8EE),
                  duration: duration.inSeconds.toDouble(),
                  position: position.inSeconds.toDouble(),
                  isPlaying: isPlaying,
                  isLoading: isLoading,
                  isPause: isPause,
                  onSeekChanged: (value) {
                    print(value);
                  },
                  onPlayPauseButtonClick: () {

                  },
                  sent: true,
                ),
              ],
            ),
            Expanded(
              child: MessageBar(
                onSend: (_) => print(_),
                actions: [
                  InkWell(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 24,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
