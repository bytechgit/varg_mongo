import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:moj_majstor/Chat.dart';
import 'package:moj_majstor/EditProfileMajstor.dart';
import 'package:moj_majstor/Review.dart';
import 'package:moj_majstor/messageList.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Inbox.dart';
import 'ReviewLinearRating.dart';
import 'messageControler.dart';
import 'models/InboxModel.dart';

class Profil extends StatefulWidget {
  final MajstorModel majstor;
  const Profil({Key? key, required this.majstor}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool fullScreenComments = false;
  final messageController = Get.find<messageControler>();
  bool isFollowing = false;
  int lenght = 4;
  List<Widget> getOccupations(List<String>? strings) {
    List<Widget> list = [];
    if (strings != null) {
      for (var i = 0; i < strings.length; i++) {
        list.add(
          Padding(
            padding: const EdgeInsets.only(right: 5, bottom: 5),
            child: Chip(
              label: Text(strings[i]),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        );
      }
    }
    return list;
  }

  List<InboxModel> inboxmodel = [];
  Color favoriteColor = Colors.grey;
  Color likeColor = Colors.grey;
  @override
  void initState() {
    super.initState();
    if (widget.majstor.comments.isEmpty) {
      widget.majstor.getComments();
    }
  }

  Future<void> _callNumber(String phoneNumber) async {
    var res = await launch("tel:$phoneNumber"); //callNumber(_number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 15, 0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileMajstor(
                                    majstor: widget.majstor)),
                          );
                        },
                        icon: const Icon(Icons.settings),
                        iconSize: 30,
                        color: Colors.white,
                        alignment: Alignment.topRight,
                      ),
                    ),
                    height: 250,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(255, 100, 121, 254),
                          Color.fromARGB(255, 144, 159, 254),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Container(
                      width: double.infinity,
                      // height: MediaQuery.of(context).size.height,
                      //     height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 85),
                          child: Column(
                            children: [
                              Text(
                                widget.majstor.fullName,
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  widget.majstor.primaryOccupation ?? "",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 35, 15, 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'Ocena',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        RatingBarIndicator(
                                          rating: widget.majstor.rate ??
                                              0, //ua.currentUser?.rate ?? 0,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 22.0,
                                          direction: Axis.horizontal,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Preporuke',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          (widget.majstor
                                                      .recommendationNumber ??
                                                  0)
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Recenzije',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          (widget.majstor.reviewsNumber ?? 0)
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      elevation: 3,
                                      child: IconButton(
                                        onPressed: () async {
                                          if (!widget.majstor.isInFavorites()) {
                                            bool result = await widget.majstor
                                                .addToFavorites(false);
                                            if (result) {
                                              Fluttertoast.showToast(
                                                msg: 'Dodato u omiljene',
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          } else {
                                            widget.majstor.addToFavorites(true);
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: widget.majstor.isInFavorites()
                                              ? const Color.fromARGB(
                                                  255, 100, 120, 254)
                                              : Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Card(
                                      elevation: 3,
                                      child: IconButton(
                                        onPressed: () async {
                                          if (!widget.majstor.isLiked()) {
                                            bool result = await widget.majstor
                                                .addLike(false);
                                            if (result) {
                                              Fluttertoast.showToast(
                                                msg: 'Liked',
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          } else {
                                            widget.majstor.addLike(true);
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: widget.majstor.isLiked()
                                              ? const Color.fromARGB(
                                                  255, 100, 120, 254)
                                              : Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Card(
                                      elevation: 3,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Chat(
                                                ml: messageController.getChat(
                                                    widget.majstor.UID),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.message,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(thickness: 1),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(
                                        bottom: 1,
                                      ),
                                      child: const Text(
                                        'Opis',
                                        style: TextStyle(
                                          fontSize: 25.0,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        widget.majstor.bio ?? "",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(thickness: 1),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: const Text(
                                        'Veštine i znanja',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 25),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Wrap(
                                            children: getOccupations(
                                                widget.majstor.occupation)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const ReviewRating(),
                              for (var c in widget.majstor.comments)
                                Review(
                                  model: c,
                                ),
                              const SizedBox(
                                height: 70,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor:
                            const Color.fromARGB(255, 126, 143, 247),
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: NetworkImage(
                            widget.majstor.profilePicture ??
                                "https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _callNumber(widget.majstor.phoneNumber ?? "0000000");
          });
        },
        child: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 100, 121, 254),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
