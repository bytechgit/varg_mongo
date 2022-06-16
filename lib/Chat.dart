import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:moj_majstor/chatBubble.dart';
import 'package:moj_majstor/messageControler.dart';
import 'package:moj_majstor/messageList.dart';
import 'package:moj_majstor/models/message.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'filter.dart';
import 'models/ChatMessage.dart';

class Chat extends StatefulWidget {
  MessageList ml;
  Chat({Key? key, required this.ml}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late File photoFile;
  final messageController = Get.find<messageControler>();
  final TextEditingController _controller = TextEditingController();
  late String messageText;
  int k = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> onRefresh() async {
    messageController.getMessages();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 100, 120, 254),
            toolbarHeight: 70,
            title: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg?w=2000'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    'Marija Krsanin',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: onRefresh,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: SingleChildScrollView(
                      child: Obx(
                        () => Column(
                            children: widget.ml
                                .getChatMessages()
                                .map((element) => chatBubble(mess: element))
                                .toList()),
                      ),
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.send,
                          ),
                          onPressed: () {
                            widget.ml.chatId == ""
                                ? widget.ml
                                    .sendMessagesNewChat(_controller.text)
                                : widget.ml.sendMessages(_controller.text);

                            // messageController.sendMessages(message(
                            //     text: _controller.text,
                            //     dateTime: DateTime.now().toString(),
                            //     sender: 'aaaa'));
                            _controller.text = '';
                          }),

                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(15),
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),

                      hintText: 'Poruka...',
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
