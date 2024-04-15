import 'dart:convert';
import 'dart:io';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/chat/data/models/message.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import '../models/chat.dart';

class ChatService {
  FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  Future<Either<FirebaseException, Unit>> sendMessage({
    required Message message,
    required bool isMerchant,
  }) async {
    try {
      final user = ConstantsManager.appUser;
      if (user is Customer) {
        await _sendMessageForUser(
          userType: 'customers',
          userId: user.id,
          receiverId: message.receiverId,
          message: message,
        );
        await _sendMessageForUser(
          userType: isMerchant ? 'merchants' : "workers",
          userId: message.receiverId,
          receiverId: user.id,
          message: message,
        );
      } else {
        await _sendMessageForUser(
          userType: isMerchant ? 'merchants' : "workers",
          userId: user!.id,
          receiverId: message.receiverId,
          message: message,
        );
        await _sendMessageForUser(
          userType: 'customers',
          userId: message.receiverId,
          receiverId: user.id,
          message: message,
        );
      }
      await _pushNotification(message: message);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Either<FirebaseException, Stream<List<Message>>> getMessage({
    required String receiverId,
    required bool isMerchant,
  }) {
    try {
      Stream<List<Message>> messages = const Stream.empty();
      final user = ConstantsManager.appUser;
      if (user is Customer) {
        messages = getMessagesForUser(
          userType: 'customers',
          userId: user.id,
          receiverId: receiverId,
        );
      } else {
        messages = getMessagesForUser(
          userType: isMerchant ? 'merchants' : "workers",
          userId: user!.id,
          receiverId: receiverId,
        );
      }
      return Right(messages);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<Either<FirebaseException, List<Chat>>> getChats() async {
    try {
      List<Chat> chats = [];
      await firebaseInstance
          .collection(
              ConstantsManager.appUser is Merchant ? "merchants" : "customers")
          .doc(ConstantsManager.appUser!.id)
          .collection("chats")
          .get()
          .then((value) {
        for (var element in value.docs) {
          chats.add(Chat.fromJson(element.data()));
        }
      });
      return Right(chats);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Future<Either<FirebaseException, Unit>> endChat(String receiverId) async {
    try {
      var batch = FirebaseFirestore.instance.batch();

      var merchant = firebaseInstance
          .collection("merchants")
          .doc(ConstantsManager.appUser!.id)
          .collection("chats")
          .doc(receiverId);
      var customer = firebaseInstance
          .collection("customers")
          .doc(receiverId)
          .collection("chats")
          .doc(ConstantsManager.appUser!.id);
      batch.update(merchant, {"isEnd": true});
      batch.update(customer, {"isEnd": true});
      batch.commit();
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  Stream<List<Message>> getMessagesForUser({
    required String userType,
    required String userId,
    required String receiverId,
  }) {
    return firebaseInstance
        .collection(userType)
        .doc(userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('createdTime', descending: false)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> value) {
      List<Message> messages = [];
      for (var element in value.docs) {
        messages.add(Message.fromJson(element.data()));
      }
      return messages;
    });
  }

  Future<void> _sendMessageForUser({
    required String userType,
    required String userId,
    required String receiverId,
    required Message message,
  }) async {
    if (message.voiceNoteFilePath != null) {
      message.voiceNoteUrl = await _uploadImageToFirebaseStorage(
          filePath: message.voiceNoteFilePath!,
          fileName:
              "audios/${message.senderId}/${Uri.file(message.voiceNoteFilePath!).pathSegments.last}");
    }
    if (message.imageFilePath != null) {
      message.imageUrl = await _uploadImageToFirebaseStorage(
          filePath: message.imageFilePath!,
          fileName:
              "images/${message.senderId}/${Uri.file(message.imageFilePath!).pathSegments.last}");
    }
    await firebaseInstance
        .collection(userType)
        .doc(userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());
  }

  Future<String> _uploadImageToFirebaseStorage(
      {required String filePath, required String fileName}) async {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    await reference.putFile(File(filePath));
    return reference.getDownloadURL();
  }

  Future<void> _pushNotification({
    required Message message,
  }) async {
    await http.post(Uri.parse(ConstantsManager.baseUrlNotification),
        body: jsonEncode({
          "to": "/topics/${message.receiverId}",
          "notification": {
            "body": message.message,
            "title": message.receiverName,
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        }),
        headers: {
          "Authorization": "key=${ConstantsManager.firebaseMessagingAPI}",
          "Content-Type": "application/json"
        });
  }
}
