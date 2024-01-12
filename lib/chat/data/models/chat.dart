import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String receiverName;
  final String receiverId;

  const Chat({
    required this.receiverId,
    required this.receiverName,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      receiverId: json["receiverId"],
      receiverName: json["receiverName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "receiverName": receiverName,
      "receiverId": receiverId,
    };
  }

  @override
  List<Object?> get props => [receiverName, receiverId];
}
