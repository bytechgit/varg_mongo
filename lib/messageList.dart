import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/messageControler.dart';
import 'package:moj_majstor/models/message.dart';

class MessageList extends GetxController with LinkedListEntry<MessageList> {
  String chatId;
  final UserAuthentication _ua = UserAuthentication();
  final messageController = Get.find<messageControler>();
  String user1Id = '';
  String user2Id = '';
  String user1Name = 'Ime Prezime';
  String user2Name = 'Ime Prezime';
  String user1Photo =
      'https://play-lh.googleusercontent.com/I-Yd5tJnxw7Ks8FUhUiFr8I4kohd9phv5sRFHG_-nSX9AAD6Rcy570NBZVFJBKpepmc=w240-h480-rw';
  String user2Photo =
      'https://play-lh.googleusercontent.com/I-Yd5tJnxw7Ks8FUhUiFr8I4kohd9phv5sRFHG_-nSX9AAD6Rcy570NBZVFJBKpepmc=w240-h480-rw';
  RxList<Message> messages = RxList();
  MessageList({required this.chatId, required this.user1Id});
  MessageList.message({required this.chatId, required Message message}) {
    messages.add(message);
  }
  String get profilePhoto {
    if (_ua.user != null) {
      if (_ua.user!.UID == user1Id) {
        return user2Photo;
      }
      return user1Photo;
    } else {
      return "https://play-lh.googleusercontent.com/I-Yd5tJnxw7Ks8FUhUiFr8I4kohd9phv5sRFHG_-nSX9AAD6Rcy570NBZVFJBKpepmc=w240-h480-rw";
    }
  }

  String get userName {
    if (_ua.user != null) {
      if (_ua.user!.UID == user1Id) {
        return user2Name;
      }
      return user1Name;
    } else {
      return "Ime Prezime Ime Prezime jjjbjjjbhkhujg ime jjjbjjjbhkhujg iuy ime jjjbjjjbhkhujg iuyhgiu iuygiyg";
    }
  }

  String get userRecieverUid {
    if (_ua.user != null) {
      if (_ua.user!.UID == user1Id) {
        return user2Id;
      }
      return user1Id;
    } else {
      return "";
    }
  }

  List<Message> getChatMessages() {
    return messages;
  }

  Future<void> sendMessagesNewChat(String text) async {
    try {
      messageController.chat.value.addFirst(this);
      messages.add(Message(
          text: text,
          dateTime: DateTime.now().toString(),
          sender: _ua.currentUser!.UID,
          chatId: chatId));
      final response = await http.post(
        Uri.parse('http://100.79.156.38:3000/sendMessageNewChat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'text': text,
          'dateTime': DateTime.now().toString(),
          'senderUid': _ua.currentUser!.UID,
          'recieverUid': userRecieverUid
        }),
      );
      if (response.statusCode == 200) {
        chatId = jsonDecode(response.body).chatId;
        for (var m in messages) {
          m.chatId = chatId;
        }
        messageController.chat.value.addFirst(this);
      }
    } catch (e) {}
  }

  Future<void> sendMessages(String text) async {
    try {
      Message message = Message(
          text: text,
          dateTime: DateTime.now().toString(),
          sender: _ua.currentUser!.UID,
          chatId: chatId);
      messages.add(message);
      final response = await http.post(
        Uri.parse('http://100.79.156.38:3000/sendMessage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'message': message.toMap(),
        }),
      );
      if (response.statusCode == 200) {}
    } catch (e) {}
  }
}
