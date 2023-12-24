import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final Timestamp createdTime;
  String? message;
  int? voiceDuration;
  final String senderId;
  String? voiceNoteUrl;
  String? voiceNoteFilePath;
  final String receiverId;
  Message({
    this.voiceNoteFilePath,
    this.voiceNoteUrl,
    required this.createdTime,
    this.message,
    this.voiceDuration,
    required this.senderId,
    required this.receiverId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      createdTime: json["createdTime"],
      message: json["message"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      voiceNoteUrl: json["voiceNoteUrl"],
      voiceDuration: json["voiceDuration"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "voiceDuration":voiceDuration,
      "senderId":senderId,
      "voiceNoteUrl":voiceNoteUrl,
      "createdTime":createdTime,
      "message":message,
      "receiverId":receiverId,
    };
  }

  @override
  List<Object?> get props => [createdTime,senderId,message,receiverId];
}
