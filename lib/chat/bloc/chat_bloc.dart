import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import '../data/models/message.dart';
import '../data/repositories/chat_repository.dart';

part 'chat_state.dart';

part 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static ChatBloc get(BuildContext context) =>
      BlocProvider.of<ChatBloc>(context);
  ChatRepository chatRepository = ChatRepository();
  String statusText = "Message";
  String? recordFilePath;
  bool isComplete = false;

  ChatBloc(ChatInitial chatInitial) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is GetMessagesEvent) {
        final result = chatRepository.getMessage(receiverId: event.receiverId);
        result.fold((l) {}, (r) {
          emit(GetMessagesSuccessState(r));
        });
      } else if (event is SendMessageEvent) {
        await chatRepository.sendMessage(message: event.message);
        emit(SendMessagesSuccessState());
      }else if (event is StartRecordEvent) {
        await startRecord();
        emit(StartRecordState());
      }else if (event is EndRecordEvent) {
        stopRecord();
        play();
        emit(EndRecordState());
      }
    });
  }
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/1.mp3";
  }

  Future<void> startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      print(recordFilePath);
      isComplete = false;
      RecordMp3.instance.start(recordFilePath!, (type) {
        statusText = "Record error--->$type";
      });
    } else {
      statusText = "No microphone permission";
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
    }
  }

  void play() {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      print("recordFilePath $recordFilePath");
      audioPlayer.play(DeviceFileSource(recordFilePath!));
    }
  }

}
