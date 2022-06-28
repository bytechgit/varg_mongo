import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/SocketIO.dart';
import 'package:moj_majstor/messageControler.dart';
import 'package:moj_majstor/models/message.dart';

class MessageList extends GetxController with LinkedListEntry<MessageList> {
  int loadedMessages = 0;
  String chatId;
  final UserAuthentication _ua = UserAuthentication();
  final messageController = Get.find<messageControler>();
  final socketController = Get.find<SocketIO>();
  String user1Id = '';
  String user2Id = '';
  String user1Name = 'Ime Prezime';
  String user2Name = 'Ime Prezime';
  String user1Photo =
      'https://play-lh.googleusercontent.com/I-Yd5tJnxw7Ks8FUhUiFr8I4kohd9phv5sRFHG_-nSX9AAD6Rcy570NBZVFJBKpepmc=w240-h480-rw';
  String user2Photo =
      'https://play-lh.googleusercontent.com/I-Yd5tJnxw7Ks8FUhUiFr8I4kohd9phv5sRFHG_-nSX9AAD6Rcy570NBZVFJBKpepmc=w240-h480-rw';
  RxList<Message> messages = RxList();
  MessageList(
      {required this.chatId,
      required this.user1Id,
      required this.user1Name,
      required this.user1Photo,
      required this.user2Id,
      required this.user2Name,
      required this.user2Photo}) {
    if (chatId != "") {
      loadChatMessages();
    }
  }

  MessageList.fromMap(Map<String, dynamic> map)
      : chatId = map["_id"],
        user1Id = map["user1Id"],
        user1Name = map["user1Name"],
        user1Photo = map["user1Photo"],
        user2Id = map["user2Id"],
        user2Name = map["user2Name"],
        user2Photo = map["user2Photo"],
        messages = (((map["messages"] ?? []) as List<dynamic>)
                .map((e) => Message.fromMap(e))
                .toList())
            .obs {
    loadedMessages = messages.length;

    socketController.socket.on(chatId, (data) {
      print("-------------------------------------------------------------");
      recieveMessage(Message.fromMap(data));
    });
  }

  MessageList.message({required this.chatId, required Message message}) {
    messages.add(message);
  }
  String get profilePhoto {
    if (_ua.user != null) {
      if (_ua.user!.UID == user1Id) {
        return user2Photo != ""
            ? user2Photo
            : "https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
      }
      return user1Photo != ""
          ? user1Photo
          : "https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
    } else {
      return "https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
    }
  }

  String get userName {
    if (_ua.user != null) {
      if (_ua.user!.UID == user1Id) {
        return user2Name;
      }
      return user1Name;
    } else {
      return "Ime Prezime";
    }
  }

  String get userRecieverUid {
    if (_ua.user != null) {
      if (_ua.user!.UID == user1Id) {
        return user2Id;
      } else
        return user1Id;
    } else {
      return "";
    }
  }

  List<Message> getChatMessages() {
    return messages;
  }

  Future<int> loadChatMessages() async {
    int pomskip = loadedMessages;
    try {
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/loadChatMessages'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'chatId': chatId,
          'skip': loadedMessages,
          'limit': 10,
        }),
      );
      if (response.statusCode == 200) {
        for (var m in jsonDecode(response.body)) {
          {
            messages.add(Message.fromMap(m));
            loadedMessages++;
          }
        }
      } else {
        inspect(jsonDecode(response.body));
      }
      return loadedMessages - pomskip;
    } catch (e) {
      inspect(e);
      return 0;
    }
  }

  Future<void> sendMessagesNewChat(String text) async {
    try {
      messageController.chat.value.addFirst(this);
      Message message = Message(
          text: text,
          dateTime: DateTime.now().toString(),
          sender: _ua.currentUser!.UID,
          chatId: "chatId");
      messages.add(message);

      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/sendMessageNewChat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'message': message.toMap(),
          'user1Id': user1Id,
          'user1Name': user1Name,
          'user1Photo': user1Photo,
          'user2Id': user2Id,
          'user2Name': user2Name,
          'user2Photo': user2Photo,
          'senderName': userName,
          'reciever': userRecieverUid,
          'image': _ua.currentUser!.profilePicture ?? ""
        }),
      );
      if (response.statusCode == 200) {
        chatId = jsonDecode(response.body)["chatId"];

        for (var m in messages) {
          m.chatId = chatId;
        }
        socketController.socket.on(chatId, (data) {
          recieveMessage(Message.fromMap(data));
        });
        // messageController.chat.value.addFirst(this);
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
        Uri.parse('http://100.101.167.63:3000/sendMessage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'message': message.toMap(),
          'senderName': userName,
          'reciever': userRecieverUid,
          'image': _ua.currentUser!.profilePicture ?? ""
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
        inspect(response.body);
      }
    } catch (e) {}
  }

  void recieveMessage(Message m) {
    unlink();
    if (m.sender != _ua.currentUser!.UID) {
      messages.add(m);
    }
    messageController.chat.value.addFirst(this);
    messageController.chat.refresh();
  }
}
