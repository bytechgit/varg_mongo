import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moj_majstor/messageList.dart';
import 'package:moj_majstor/models/InboxModel.dart';

import 'Chat.dart';

class CardInbox extends StatelessWidget {
  late MessageList _model;

  CardInbox({
    Key? key,
    required MessageList model,
  }) : super(key: key) {
    _model = model;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    ml: _model,
                  )),
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          height: 80,
          width: double.infinity,
          //  margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              //Row(
              // children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: CircleAvatar(
                          radius: 33.0,
                          backgroundImage: NetworkImage(_model.profilePhoto),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        _model.userName,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        _model.messages.last.dateTime,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  _model.messages.last.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
              ),
            ],
          ),
          // ],
        ),
      ),
    );
  }
}
