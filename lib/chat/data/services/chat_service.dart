// import 'package:almasheed/authentication/data/models/customer.dart';
// import 'package:almasheed/chat/data/models/message.dart';
// import 'package:almasheed/core/utils/constance_manager.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
//
// class ChatService {
//   FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
//
//   Future<Either<FirebaseException, Unit>> sendMessage({
//     required Message message,
//   }) async {
//     try {
//       final user = ConstantsManager.appUser;
//       if (user is Customer) {
//         await _sendMessageForUser(
//           userType: 'customers',
//           userId: user.id,
//           receiverId: message.receiverId,
//           message: message,
//         );
//         await _sendMessageForUser(
//           userType: 'merchants',
//           userId: message.receiverId,
//           receiverId: user.id,
//           message: message,
//         );
//       } else {
//         await _sendMessageForUser(
//           userType: 'merchants',
//           userId: user!.id,
//           receiverId: message.receiverId,
//           message: message,
//         );
//         await _sendMessageForUser(
//           userType: 'customers',
//           userId: message.receiverId,
//           receiverId: user.id,
//           message: message,
//         );
//       }
//       return const Right(unit);
//     } on FirebaseException catch (e) {
//       return Left(e);
//     }
//   }
//
//   Either<FirebaseException, List<Message>> getMessage(
//       {required String receiverId}) {
//     try {
//       List<Message> messages = [];
//       final user = ConstantsManager.appUser;
//       if (user is Customer) {
//         _getMessagesForUser(
//           userType: 'customers',
//           userId: user.id,
//           receiverId: receiverId,
//           messages: messages,
//         );
//       } else {
//         _getMessagesForUser(
//           userType: 'merchants',
//           userId: user!.id,
//           receiverId: receiverId,
//           messages: messages,
//         );
//       }
//       return Right(messages);
//     } on FirebaseException catch (e) {
//       return Left(e);
//     }
//   }
//
//   void _getMessagesForUser({
//     required String userType,
//     required String userId,
//     required String receiverId,
//     required List<Message> messages,
//   }) {
//     firebaseInstance
//         .collection(userType)
//         .doc(userId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('messages')
//         .orderBy('createdTime', descending: false)
//         .snapshots()
//         .listen((value) {
//       messages.clear();
//       for (var element in value.docs) {
//         messages.add(Message.fromJson(element.data()));
//       }
//     });
//   }
//
//   Future<void> _sendMessageForUser({
//     required String userType,
//     required String userId,
//     required String receiverId,
//     required Message message,
//   }) async {
//     await firebaseInstance
//         .collection(userType)
//         .doc(userId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('messages')
//         .add(message.toJson());
//   }
// }
