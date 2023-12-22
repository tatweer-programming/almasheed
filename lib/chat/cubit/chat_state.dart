part of 'chat_cubit.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
}

class GetMessagesSuccess extends ChatState {
  final List<Message> messages;
  const GetMessagesSuccess(this.messages);
}
class SendMessageSuccess extends ChatState {
  final List<Message> messages;
  const SendMessageSuccess(this.messages);
}
class SendMessagesFailure extends ChatState {
  final FirebaseException error;
  const SendMessagesFailure(this.error);
}
