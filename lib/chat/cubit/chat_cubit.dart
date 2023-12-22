import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/data/models/customer.dart';
import '../../core/utils/constance_manager.dart';
import '../data/models/message.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  void getMessages({required String receiverId}) {
    List<Message> messages = [];

    final user = ConstantsManager.appUser;

    if (user is Customer) {
      _getMessagesForUser(
          userType: 'customers',
          userId: user.id,
          receiverId: receiverId,
          messages: messages);
    } else {
      _getMessagesForUser(
          userType: 'merchants',
          userId: user!.id,
          receiverId: receiverId,
          messages: messages);
    }
  }

  Future<void> sendMessage({required Message message}) async {
    try {
      final user = ConstantsManager.appUser;

      if (user is Customer) {
        await _sendMessageForUser(
            userType: 'customers',
            userId: user.id,
            receiverId: message.receiverId,
            message: message);
        await _sendMessageForUser(
            userType: 'merchants',
            userId: message.receiverId,
            receiverId: user.id,
            message: message);
      } else {
        await _sendMessageForUser(
            userType: 'merchants',
            userId: user!.id,
            receiverId: message.receiverId,
            message: message);
        await _sendMessageForUser(
            userType: 'customers',
            userId: message.receiverId,
            receiverId: user.id,
            message: message);
      }
    } on FirebaseException catch (error) {
      emit(SendMessagesFailure(error));
    }
  }

  void _getMessagesForUser(
      {required String userType,
      required String userId,
      required String receiverId,
      required List<Message> messages}) {
    _firebaseInstance
        .collection(userType)
        .doc(userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('createdTime', descending: false)
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        messages.add(Message.fromJson(element.data()));
      }
      emit(GetMessagesSuccess(messages));
    });
  }

  Future<void> _sendMessageForUser(
      {required String userType,
      required String userId,
      required String receiverId,
      required Message message}) async {
    await _firebaseInstance
        .collection(userType)
        .doc(userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());
  }
}
