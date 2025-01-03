import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../data/models/chat.dart';
import '../data/models/message.dart';
import '../data/repositories/chat_repository.dart';

part 'chat_state.dart';

part 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static ChatBloc get(BuildContext context) =>
      BlocProvider.of<ChatBloc>(context);
  ChatRepository chatRepository = ChatRepository();
  AudioPlayer audioPlayer = AudioPlayer();
  String statusText = "Message";
  String? voiceNoteFilePath;

  // double voiceDuration = 0;
  bool isComplete = false;
  bool isPlaying = false;
  int voiceNoteDuration = 0;
  String? imageFilePath;
  List<Chat> chats = [];
  Record record = Record();

  ChatBloc(ChatInitial chatInitial) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is GetMessagesEvent) {
        final result = chatRepository.getMessage(
            receiverId: event.receiverId, isMerchant: event.isMerchant);
        result.fold((l) {}, (r) {
          emit(GetMessagesSuccessState(r));
        });
      } else if (event is SendMessageEvent) {
        await chatRepository.sendMessage(
            message: event.message, isMerchant: event.isMerchant);
        emit(SendMessagesSuccessState());
      } else if (event is GetChatsEvent) {
        var result = await chatRepository.getChats();
        result.fold((l) {
          emit(GetChatErrorState());
        }, (r) {
          chats = r;
          emit(GetChatSuccessfullyState());
        });
      } else if (event is StartRecordingEvent) {
        await startRecord();
        emit(StartRecordState());
      } else if (event is EndRecordingEvent) {
        await stopRecord();
        emit(EndRecordState());
      } else if (event is EndChatEvent) {
        var result =
            await chatRepository.endChat(event.receiverId, event.isMerchant);
        result.fold((l) {
          emit(EndChatErrorState(l));
        }, (r) {
          emit(EndChatSuccessState());
        });
      } else if (event is ScrollingDownEvent) {
        // if (event.listScrollController.hasClients) {
        Future.delayed(const Duration(seconds: 1)).then((value) async {
          final position = event.listScrollController.position.maxScrollExtent;
          event.listScrollController.jumpTo(position);
        });
        emit(ScrollingDownState());
        // }
      } else if (event is TurnOnRecordUrlEvent) {
        if (!event.isPlaying) {
          await audioPlayer.play(UrlSource(event.voiceNoteUrl));
          event.isPlaying = true;
        } else {
          await audioPlayer.stop();
          event.isPlaying = false;
        }
        emit(PlayRecordUrlState(
            voiceNoteUrl: event.voiceNoteUrl, isPlaying: event.isPlaying));
        audioPlayer.onPlayerComplete.listen((_) {
          add(CompleteRecordEvent(
              isFile: false,
              voiceNote: event.voiceNoteUrl,
              isPlaying: event.isPlaying));
        });
      } else if (event is TurnOnRecordFileEvent) {
        await audioPlayer.play(DeviceFileSource(voiceNoteFilePath!));
        isPlaying = true;
        emit(PlayRecordFileState());
        audioPlayer.onPlayerComplete.listen((_) {
          add(CompleteRecordEvent(
              isFile: true,
              voiceNote: voiceNoteFilePath!,
              isPlaying: isPlaying));
        });
      } else if (event is CompleteRecordEvent) {
        if (event.isFile) {
          isPlaying = false;
          emit(CompleteRecordFileState());
        } else {
          event.isPlaying = false;
          emit(CompleteRecordUrlState(
              voiceNoteUrl: event.voiceNote, isPlaying: event.isPlaying));
        }
      } else if (event is PickImageEvent) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          imageFilePath = pickedFile.path;
          emit(PickImageState());
        }
      } else if (event is RemovePickedImageEvent) {
        imageFilePath = null;
        emit(RemovePickedImageState());
      } else if (event is RemoveRecordEvent) {
        voiceNoteFilePath = null;
        emit(RemoveRecordState());
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
    return "$sdPath/${DateTime.now().millisecondsSinceEpoch.toString()}.mp3";
  }

  Future<void> startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer
          .play(AssetSource("audios/notiication_start_recording.wav"));
      statusText = "Recording...";
      audioPlayer.onPlayerComplete.listen((_) async {
        voiceNoteFilePath = await getFilePath();
        statusText = "Message";
        isComplete = false;
        if (await record.hasPermission()) {
          record.start();
        }
      });
    } else {
      statusText = "No microphone permission";
    }
  }

  Future<void> stopRecord() async {
    AudioPlayer audioPlayer = AudioPlayer();
    voiceNoteFilePath = await record.stop();
    double seconds = 0;
    await audioPlayer.setSource(DeviceFileSource(voiceNoteFilePath!));
    await audioPlayer.getDuration().then((value) {
      if (value != null) {
        seconds = value.inSeconds.toDouble();
      }
    });
    voiceNoteDuration = seconds.round();
    AudioPlayer audioPlayerAsset = AudioPlayer();
    await audioPlayerAsset
        .play(AssetSource("audios/notiication_end_recording.wav"));
    audioPlayerAsset.onPlayerComplete.listen((_) {
      if (voiceNoteFilePath != null) {
        statusText = "Message";
        isComplete = true;
      }
    });
  }
}
