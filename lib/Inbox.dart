import 'package:flutter/material.dart';
import 'package:moj_majstor/CardInbox.dart';
import 'package:moj_majstor/models/InboxModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moj_majstor/Search.dart';
import 'package:moj_majstor/Chat.dart';

import 'Chat.dart';

class Inbox extends StatefulWidget {
  Inbox({Key? key, required List<InboxModel> models}) : super(key: key) {
    _models = models;
  }

  List<InboxModel> _models = [];
  @override
  State<Inbox> createState() => _InboxState(_models);
}

class _InboxState extends State<Inbox> {
  _InboxState(List<InboxModel> models) {
    this._models = models;
  }

  late List<InboxModel> _models;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: SafeArea(
                child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Poruke',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Imate 2 nove poruke',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Search()),
                        );
                      },
                      icon: const Icon(Icons.search),
                      iconSize: 30,
                      color: Colors.white,
                      alignment: Alignment.topRight,
                    ),
                  ),
                )
              ],
            )),
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 100, 120, 254),
                  Color.fromARGB(195, 107, 92, 204),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ..._models
                    .map(
                      (InboxModel element) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Chat()),
                          );
                        },
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: const Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.archive,
                                label: 'Arhiviraj',
                              ),
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: const Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Obriši',
                              ),
                            ],
                          ),
                          child: CardInbox(
                            model: element,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
