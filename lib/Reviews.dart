import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moj_majstor/AddRate.dart';
import 'package:moj_majstor/Review.dart';
import 'package:moj_majstor/models/Comment.dart';
import 'package:moj_majstor/models/ReviewModel.dart';

class Reviews extends StatefulWidget {
  Reviews({Key? key, required List<Comment> models}) : super(key: key) {
    _models = models;
  }
  late List<Comment> _models;

  @override
  State<Reviews> createState() => _ReviewsState(_models);
}

class _ReviewsState extends State<Reviews> {
  _ReviewsState(List<Comment> models) {
    this._models = models;
  }

  String? commentText;
  double _currentRating = 0;
  String _textError = "";

  late List<Comment> _models;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ..._models
                    .map(
                      (Comment element) => Review(model: element),
                    )
                    .toList(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              //color: Colors.white,
              width: double.infinity,
              child: Builder(builder: (context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, bottom: 5, top: 5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 100, 120, 254),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddRate();
                              }).then((value) {
                            Comment proba = value as Comment;

                            setState(() {
                              _models.add(proba); //TO DO treba da upamti u bazu
                            });
                          });
                        },
                        child: const Text('Dodaj komentar')),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
