// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../data/models/message.dart';
// import '../data/repositories/chat_repository.dart';
//
// part 'chat_state.dart';
//
// part 'chat_event.dart';
//
// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   static ChatBloc get(BuildContext context) =>
//       BlocProvider.of<ChatBloc>(context);
//
//   ChatBloc() : super(ChatInitial()) {
//     on<GetMessagesEvent>((event, emit) {
//       _mapGetMessagesToState(event.receiverId, emit);
//     });
//
//     on<SendMessageEvent>((event, emit) async {
//       await _mapSendMessageToState(event.message, emit);
//     });
//   }
//
//   ChatRepository chatRepository = ChatRepository();
//
//   Future<void> _mapGetMessagesToState(
//       String receiverId, Emitter<ChatState> emit) async {
//     final result = await chatRepository.getMessage(receiverId: receiverId);
//     result.fold((l) {}, (r) {
//       emit(GetMessagesSuccess(r));
//     });
//   }
//
//   Future<void> _mapSendMessageToState(Message message, Emitter<ChatState> emit) async {
//     await chatRepository.sendMessage(message: message);
//     emit(SendMessagesSuccess());
//   }
// }
