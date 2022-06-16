import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/Chat.dart';
import 'package:moj_majstor/messageList.dart';
import 'models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class messageControler extends GetxController {
  var messages = [].obs;
  UserAuthentication ua = UserAuthentication();
  MessageList? currentChat;
  var chat = LinkedList<MessageList>().obs;
  //String chat = "629770e14adc6793a07d287e";
  void sendMessage({required String text}) {
    messages.add(Message(
        text: text,
        dateTime: DateTime.now().toString(),
        sender: 'sender',
        chatId: ""));

    //send message
  }

  messageControler() {}
  Future<int> getMessages() async {
    try {
      int k = messages.length;
      final response = await http.post(
        Uri.parse('http://100.79.156.38:3000/getMessages'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'skip': messages.length,
          'chat': currentChat,
          'limit': 10,
        }),
      );
      if (response.statusCode == 200) {
        for (var m in jsonDecode(response.body)) {
          {
            messages.add(Message.fromMap(m));
          }
        }
      }
      return messages.length - k;
    } catch (e) {
      return 0;
    }
  }

  Future<void> sendMessages(String text, String chatid) async {
    try {
      Message message = Message(
          text: text,
          dateTime: DateTime.now().toString(),
          sender: ua.currentUser!.UID,
          chatId: chatid);
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

  Future<void> sendMessagesNewChat(String text, String reciever_uid) async {
    try {
      final response = await http.post(
        Uri.parse('http://100.79.156.38:3000/sendMessageNewChat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'text': text,
          'dateTime': DateTime.now().toString(),
          'senderUid': ua.currentUser!.UID,
          'recieverUid': reciever_uid
        }),
      );
      if (response.statusCode == 200) {}
    } catch (e) {}
  }

  MessageList getChatMessages(String chatId) {
    return chat.value.firstWhere((element) => element.chatId == chatId,
        orElse: () {
      var ml = MessageList(chatId: "", user1Id: "");
      chat.value.addFirst(ml);
      return ml;
    });
  }

  MessageList getChat(String uid) {
    return chat.value.firstWhere(
        (element) => element.user1Id == uid || element.user2Id == uid,
        orElse: () {
      return MessageList(chatId: "", user1Id: uid);
    });
  }

  void recieveMessage(Message m) {
    bool found = true;
    MessageList mlist = chat.value.firstWhere(
      (element) => element.chatId == m.chatId,
      orElse: () {
        var ml = MessageList.message(chatId: m.chatId, message: m);
        chat.value.addFirst(ml);
        found = false;
        return ml;
      },
    );
    if (found) {
      mlist.unlink();
      mlist.messages.add(m);
      chat.value.addFirst(mlist);
    }
    //inspect(chat);
    chat.refresh();
  }

  late IO.Socket socket;
  void initializeSocket() {
    print("object");
    socket = IO.io("http://100.101.167.63:3000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    //SOCKET EVENTS
    // --> listening for connection
    socket.on('connect', (data) {
      print(socket.connected);
    });

    //listen for incoming messages from the Server.
    socket.on('12345', (data) {
      recieveMessage(Message.fromMap(data));
    });

    //listens when the client is disconnected from the Server
    socket.on('disconnect', (data) {
      print('disconnect');
    });
  }
}
