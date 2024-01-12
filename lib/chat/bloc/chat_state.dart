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

class RemovePickedImageState extends ChatState {}

class GetChatSuccessfullyState extends ChatState {}

class GetChatErrorState extends ChatState {}

class RemoveRecordState extends ChatState {}

class EndRecordState extends ChatState {}

class PlayRecordUrlState extends ChatState {
  final String voiceNoteUrl;
  final bool isPlaying;

  PlayRecordUrlState({required this.voiceNoteUrl, required this.isPlaying});
}

class PlayRecordFileState extends ChatState {}

class CompleteRecordUrlState extends ChatState {
  final String voiceNoteUrl;
  final bool isPlaying;

  CompleteRecordUrlState({required this.voiceNoteUrl, required this.isPlaying});
}

class CompleteRecordFileState extends ChatState {}
