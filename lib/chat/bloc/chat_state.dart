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
class EndRecordState extends ChatState {}
