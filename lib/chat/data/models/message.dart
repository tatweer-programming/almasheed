import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
//ignore: must_be_immutable
class Message extends Equatable {
  final Timestamp createdTime;
  String? message;
  String? imageUrl;
  String? imageFilePath;
  final String senderId;
  final String receiverName;
  String? voiceNoteUrl;
  String? voiceNoteFilePath;
  final String receiverId;
  Message({
    this.voiceNoteFilePath,
    this.voiceNoteUrl,
    this.imageUrl,
    this.message,
    this.imageFilePath,
    required this.createdTime,
    required this.senderId,
    required this.receiverName,
    required this.receiverId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      imageUrl: json["imageUrl"],
      createdTime: json["createdTime"],
      message: json["message"],
      receiverName: json["receiverName"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      voiceNoteUrl: json["voiceNoteUrl"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "senderId":senderId,
      "voiceNoteUrl":voiceNoteUrl,
      "receiverName":receiverName,
      "imageUrl":imageUrl,
      "createdTime":createdTime,
      "message":message,
      "receiverId":receiverId,
    };
  }

  @override
  List<Object?> get props => [createdTime,senderId,message,receiverId];
}
