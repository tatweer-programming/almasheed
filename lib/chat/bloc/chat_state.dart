part of 'chat_bloc.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}

class GetMessagesSuccessState extends ChatState {
  final Stream<List<Message>> messages;

  const GetMessagesSuccessState(this.messages);
}

class SendMessagesSuccessState extends ChatState {}

class StartRecordState extends ChatState {}

class PickImageState extends ChatState {}

class EndRecordState extends ChatState {}

class PlayRecordState extends ChatState {
  final String voiceNoteUrl;
  final bool isPlaying;

  PlayRecordState({required this.voiceNoteUrl, required this.isPlaying});
}

class CompleteRecordState extends ChatState {
  final String voiceNoteUrl;
  final bool isPlaying;

  CompleteRecordState({required this.voiceNoteUrl, required this.isPlaying});
}
