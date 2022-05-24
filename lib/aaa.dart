import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moj_majstor/ProfilePreview.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'package:moj_majstor/tag.dart';

import 'PhoneNumber.dart';

class Majstor extends StatefulWidget {
  final MajstorModel majstor;
  const Majstor({Key? key, required this.majstor}) : super(key: key);

  @override
  State<Majstor> createState() => _MajstorState();
}

class _MajstorState extends State<Majstor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
          child: InkWell(
            onTap: () => {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return ProfilePreview(
                    majstor: widget.majstor,
                  );
                },
              )
            },
            child: SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(widget
                                .majstor.profilePicture ??
                            "https://www.jestiveslike.com/wp-content/uploads/2016/06/builder_bob_-_majstor_bob_03.jpg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            widget.majstor.fullName,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Century'),
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
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              RatingBarIndicator(
                                rating: 3,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
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
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 30,
                          width: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Tag(text: "text"),
                              Tag(text: "11111111"),
                              Tag(text: "11111111"),
                              Tag(text: "11111111")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Center(
                    child: InkWell(
                      child: const Icon(
                        Icons.arrow_right,
                        size: 50,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const PhoneNumber();
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 2,
          height: 2,
          color: Color.fromARGB(255, 240, 240, 240),
        )
      ],
    );
  }
}
