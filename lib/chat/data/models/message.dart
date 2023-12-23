import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final Timestamp createdTime;
  final String message;
  final String senderId;
  File? voiceNoteFile;
  final String receiverId;
  Message({
    this.voiceNoteFile,
    required this.createdTime,
    required this.message,
    required this.senderId,
    required this.receiverId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      createdTime: json["createdTime"],
      message: json["message"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "senderId":senderId,
      "createdTime":createdTime,
      "message":message,
      "receiverId":receiverId,
    };
  }

  @override
  List<Object?> get props => [createdTime,senderId,message,receiverId];
}
