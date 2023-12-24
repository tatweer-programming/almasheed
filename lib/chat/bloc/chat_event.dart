part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class GetMessagesEvent extends ChatEvent {
  final String receiverId;

  const GetMessagesEvent({required this.receiverId});
}

class SendMessageEvent extends ChatEvent {
  final Message message;

  const SendMessageEvent({required this.message});
}

class StartRecordingEvent extends ChatEvent {}

class EndRecordingEvent extends ChatEvent {}

class TurnOnRecordEvent extends ChatEvent {
  final String voiceNoteUrl;
  bool isPlaying;
  TurnOnRecordEvent({required this.voiceNoteUrl,required this.isPlaying});
}
class CompleteRecordEvent extends ChatEvent {
  bool isPlaying;
  final String voiceNoteUrl;
  CompleteRecordEvent({required this.voiceNoteUrl,required this.isPlaying});
}
class OnSeekChangedEvent extends ChatEvent {
  final double duration;
  OnSeekChangedEvent({required this.duration});
}
