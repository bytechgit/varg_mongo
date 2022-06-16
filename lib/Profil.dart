import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/EditProfileMajstor.dart';
import 'package:moj_majstor/Review.dart';
import 'package:moj_majstor/Reviews.dart';
import 'package:moj_majstor/models/ReviewModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moj_majstor/ProfilePreview.dart';
import 'package:moj_majstor/EditProfileMajstor.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/Majstor.dart';

class Profil extends StatefulWidget {
  const Profil({
    Key? key,
  }) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool fullScreenComments = false;
  bool isFollowing = false;
  int lenght = 4;
  List<Widget> getOccupations(List<String>? strings) {
    List<Widget> list = [];
    if (strings != null) {
      for (var i = 0; i < strings.length; i++) {
        list.add(
          Padding(
            padding: EdgeInsets.only(right: 5, bottom: 5),
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

  Color favoriteColor = Colors.grey;
  Color likeColor = Colors.grey;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _callNumber(String phoneNumber) async {
    var res = await launch("tel:$phoneNumber"); //callNumber(_number);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuthentication>(
      builder: (context, ua, child) => Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileMajstor(
                                      majstor: MajstorModel(
                                          UID: '11111',
                                          fullName: 'Sasa Stojiljkovic',
                                          occupation: ['aaaas']),
                                    )),
                          );
                        },
                        icon: Icon(Icons.settings),
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
                      decoration: BoxDecoration(
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
                                ua.currentUser?.fullName ?? "",
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(
                                  ua.currentUser?.primaryOccupation ?? "aa",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
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
                                        Text(
                                          'Ocena',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        RatingBarIndicator(
                                          rating: ua.currentUser?.rate ?? 0,
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
                                        Text(
                                          'Preporuke',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          (ua.currentUser
                                                      ?.recommendationNumber ??
                                                  0)
                                              .toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Recenzije',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          (ua.currentUser?.reviewsNumber ?? 0)
                                              .toString(),
                                          style: TextStyle(fontSize: 20),
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
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (favoriteColor ==
                                                  Colors.grey) {
                                                Fluttertoast.showToast(
                                                  msg: 'Dodato u omiljene',
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                                favoriteColor = Color.fromARGB(
                                                    255, 100, 120, 254);
                                              } else
                                                favoriteColor = Colors.grey;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: favoriteColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (likeColor == Colors.grey) {
                                              Fluttertoast.showToast(
                                                msg: 'Preporučeno',
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              likeColor = Color.fromARGB(
                                                  255, 100, 120, 254);
                                            } else
                                              likeColor = Colors.grey;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: likeColor,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: false,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                //TO DO ucitavanje iz baze liste komentara
                                                List<ReviewModel> models =
                                                    []; // = List<ReviewModel>();
                                                models.add(ReviewModel(
                                                    profileImage:
                                                        "https://lh3.googleusercontent.com/ogw/ADea4I6uQeJPyoCB5xCXF5eKxHM_NEKnu6V0iE__X4fA=s64-c-mo",
                                                    fullName: "Marija Krsanin",
                                                    rate: 3,
                                                    commentText:
                                                        "Marijin komentar"));
                                                return Reviews(models: []);
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.comment,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1),
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
                                        ua.currentUser?.description ?? "",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1),
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
                                                ua.currentUser?.occupation)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                        backgroundColor: Color.fromARGB(255, 126, 143, 247),
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: NetworkImage(
                            ua.currentUser?.profilePicture ??
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _callNumber(ua.currentUser?.phoneNumber ?? "0000000");
            });
          },
          child: const Icon(
            Icons.phone,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 100, 121, 254),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
