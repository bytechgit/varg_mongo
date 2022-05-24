import 'package:flutter/material.dart';
import 'package:moj_majstor/models/InboxModel.dart';

class CardInbox extends StatelessWidget {
  late InboxModel _model;

  CardInbox({
    Key? key,
    required InboxModel model,
  }) : super(key: key) {
    _model = model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _model.name,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                _model.time,
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _model.lastMessage,
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
    );
  }
}
