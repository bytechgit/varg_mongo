import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/Chat.dart';
import 'package:moj_majstor/SocketIO.dart';
import 'package:moj_majstor/messageList.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'models/message.dart';

class messageControler extends GetxController {
  var messages = [].obs;
  UserAuthentication ua = UserAuthentication();
  MessageList? currentChat;
  final socketControler = Get.find<SocketIO>();
  var chat = LinkedList<MessageList>().obs;
  //String chat = "629770e14adc6793a07d287e";

  /*
  void sendMessage({required String text}) {
    messages.add(Message(
        text: text,
        dateTime: DateTime.now().toString(),
        sender: 'sender',
        chatId: ""));

    //send message
  }*/

  messageControler() {
    if (ua.currentUser != null) {
      socketControler.socket.on('recieveNewChatMessage_' + ua.currentUser!.UID,
          (ml) {
        recieveNewChatMessage(MessageList.fromMap(ml));
      });
    }

    ua.Events.stream.listen((String event) {
      if (event == "SignIn") {
        loadAllChats();
        socketControler.socket
            .on('recieveNewChatMessage_' + ua.currentUser!.UID, (ml) {
          recieveNewChatMessage(MessageList.fromMap(ml));
        });
      }
    });
    //listen for incoming messages from the Server.
  }

/*
  Future<int> getMessages() async {
    try {
      int k = messages.length;
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/getMessages'),
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
  */
/*
  Future<void> sendMessages(String text, String chatid) async {
    try {
      Message message = Message(
          text: text,
          dateTime: DateTime.now().toString(),
          sender: ua.currentUser!.UID,
          chatId: chatid);
      messages.add(message);
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/sendMessage'),
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
  */
/*
  Future<void> sendMessagesNewChat(String text, String reciever_uid) async {
    try {
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/sendMessageNewChat'),
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
  */
/*
  MessageList getChatMessages(String chatId) {
    //izgleda da se ne koristi
    return chat.value.firstWhere((element) => element.chatId == chatId,
        orElse: () {
      var ml = MessageList(
          chatId: "",
          user1Id: "",
          user1Name: "",
          user1Photo: "",
          user2Id: "",
          user2Name: "",
          user2Photo: "");
      chat.value.addFirst(ml);
      return ml;
    });
  }*/

  Future<int> loadAllChats() async {
    try {
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/loadAllChats'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'uid': ua.user!.UID,
        }),
      );
      if (response.statusCode == 200) {
        for (var c in jsonDecode(response.body)) {
          {
            //  messages.add(Message.fromMap(m));
            //    print("-----------------" + c["_id"]);
            chat.value.addFirst(MessageList.fromMap(c));
          }
        }
      }
      return 1;
    } catch (e) {
      return 0;
    }
  }

  MessageList getChat(MajstorModel majstor) {
    return chat.value.firstWhere(
        (element) =>
            element.user1Id == majstor.UID || element.user2Id == majstor.UID,
        orElse: () {
      return MessageList(
          chatId: "",
          user1Id: ua.user!.UID,
          user1Name: ua.user!.fullName,
          user1Photo: ua.user!.profilePicture ?? "",
          user2Id: majstor.UID,
          user2Name: majstor.fullName,
          user2Photo: majstor.profilePicture ?? "");
    });
  }

  void recieveNewChatMessage(MessageList ml) {
    chat.value.addFirst(ml);
    chat.refresh();
  }

  /*void initializeSocket() {
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
  }*/
}
