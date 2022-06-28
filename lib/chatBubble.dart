import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/models/message.dart';

class chatBubble extends StatelessWidget {
  Message mess;
  chatBubble({Key? key, required this.mess}) : super(key: key);
  UserAuthentication ua = UserAuthentication();
  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: mess.sender == ua.currentUser?.UID
          ? ChatBubbleClipper2(type: BubbleType.sendBubble)
          : ChatBubbleClipper2(type: BubbleType.receiverBubble),
      alignment: mess.sender == ua.currentUser?.UID
          ? Alignment.topRight
          : Alignment.topLeft,
      margin: EdgeInsets.only(top: 10),
      backGroundColor:
          mess.sender == ua.currentUser?.UID ? Colors.blue[100] : Colors.white,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          mess.text + " ", // + mess.dateTime.,
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
