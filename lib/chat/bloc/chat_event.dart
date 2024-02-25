part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class GetMessagesEvent extends ChatEvent {
  final String receiverId;

  const GetMessagesEvent({required this.receiverId});
}

class EndChatEvent extends ChatEvent {
  final String receiverId;

  const EndChatEvent({required this.receiverId});
}

class SendMessageEvent extends ChatEvent {
  final Message message;

  const SendMessageEvent({required this.message});
}

class PickImageEvent extends ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class RemovePickedImageEvent extends ChatEvent {}

class RemoveRecordEvent extends ChatEvent {}

class StartRecordingEvent extends ChatEvent {}

class EndRecordingEvent extends ChatEvent {}

class ScrollingDownEvent extends ChatEvent {
  final ScrollController listScrollController;

  ScrollingDownEvent({required this.listScrollController});
}

class TurnOnRecordUrlEvent extends ChatEvent {
  final String voiceNoteUrl;
  bool isPlaying;

  TurnOnRecordUrlEvent({required this.voiceNoteUrl, required this.isPlaying});
}

class TurnOnRecordFileEvent extends ChatEvent {
  final String voiceNoteUrl;
  bool isPlaying;

  TurnOnRecordFileEvent({required this.voiceNoteUrl, required this.isPlaying});
}

class CompleteRecordEvent extends ChatEvent {
  bool isPlaying;
  final bool isFile;
  final String voiceNote;

  CompleteRecordEvent(
      {required this.voiceNote, required this.isFile, required this.isPlaying});
}
