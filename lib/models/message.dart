import 'dart:collection';

class Message {
  String text;
  String dateTime;
  String sender;
  String chatId;
  Message(
      {required this.text,
      required this.dateTime,
      required this.sender,
      required this.chatId});
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'sender': sender,
      'chatId': chatId
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : text = map["text"],
        dateTime = map["dateTime"],
        sender = map["sender"],
        chatId = map["chatId"];
}
