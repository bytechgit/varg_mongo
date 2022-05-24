import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moj_majstor/ProfilePreview.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'package:moj_majstor/tag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'PhoneNumber.dart';

class Majstor extends StatefulWidget {
  final MajstorModel majstor;
  const Majstor({Key? key, required this.majstor}) : super(key: key);

  @override
  State<Majstor> createState() => _MajstorState();
}

class _MajstorState extends State<Majstor> {
  List<Widget> getOccupations(List<String>? strings) {
    List<Widget> list = [];
    if (strings != null) {
      for (var i = 0; i < strings.length; i++) {
        list.add(Tag(text: strings[i]));
      }
    }
    return list;
  }

  Widget icon = Icon(
    Icons.star_border,
    color: Color.fromARGB(255, 144, 159, 254),
    size: 40,
  );
  bool ic = true;
  void doNothing(BuildContext context) {}
  Future<void> _callNumber(BuildContext context) async {
    var res = await launch(
        "tel:" + (widget.majstor.phoneNumber ?? "000")); //callNumber(_number);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return ProfilePreview(
              majstor: widget.majstor,
            );
          },
        );
      },
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 1,
              onPressed: _callNumber,
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.call,
              label: 'Pozovi',
            ),
            SlidableAction(
              onPressed: doNothing,
              backgroundColor: Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.message,
              label: 'Poruka',
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 5),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (ic == true) {
                          icon = Icon(
                            Icons.star_border,
                            color: Color.fromARGB(255, 144, 159, 254),
                            size: 40,
                          );
                        } else {
                          icon = Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 144, 159, 254),
                            size: 40,
                          );
                        }
                        ic = !ic;
                      });
                    },
                    icon: icon),
              ),
            ),
            Column(children: [
              SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 10),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Color.fromARGB(255, 84, 106, 255),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundImage: NetworkImage(widget
                                  .majstor.profilePicture ??
                              "https://www.jestiveslike.com/wp-content/uploads/2016/06/builder_bob_-_majstor_bob_03.jpg"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 100),
                                child: Text(
                                  widget.majstor.fullName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 1.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Century'),
                                ),
                              ),
                            ),
                            const FittedBox(
                              child: Text(
                                'zanimanje: Elektricar',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    //fontWeight: FontWeight.bold,
                                    fontFamily: 'Century'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 10, left: 5),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: 3,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 144, 159, 254),
                                    ),
                                    itemCount: 5,
                                    itemSize: 22.0,
                                    direction: Axis.horizontal,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      '120',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Century'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: SizedBox(
                                  height: 40,
                                  // width: 150,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: getOccupations(
                                        widget.majstor.occupation),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
              )
            ]),
          ],
        ),
      ),
    );
  }
}
