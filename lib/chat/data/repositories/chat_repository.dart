import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../services/chat_service.dart';

class ChatRepository {
  ChatService service = ChatService();

  Either<FirebaseException, Stream<List<Message>>> getMessage({
    required String receiverId,
    required bool isMerchant,
  }) {
    return service.getMessage(receiverId: receiverId, isMerchant: isMerchant);
  }

  Future<Either<FirebaseException, Unit>> endChat(String receiverId) {
    return service.endChat(receiverId);
  }

  Future<Either<FirebaseException, Unit>> sendMessage({
    required Message message,
    required bool isMerchant,
  }) async {
    return await service.sendMessage(message: message, isMerchant: isMerchant);
  }

  Future<Either<FirebaseException, List<Chat>>> getChats() async {
    return await service.getChats();
  }
}
