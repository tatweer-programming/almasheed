import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class Chat extends Equatable {
  final String receiverName;
  final String receiverId;
  bool isEnd;
  final bool isMerchant;

  Chat({
    required this.receiverId,
    required this.receiverName,
    required this.isEnd,
    required this.isMerchant,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      receiverId: json["receiverId"],
      isEnd: json["isEnd"],
      isMerchant: json["isMerchant"],
      receiverName: json["receiverName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "receiverName": receiverName,
      "receiverId": receiverId,
      "isEnd": isEnd,
      "isMerchant": isMerchant,
    };
  }

  @override
  List<Object?> get props => [receiverName, receiverId];
}
