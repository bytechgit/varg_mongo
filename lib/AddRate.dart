import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moj_majstor/models/ReviewModel.dart';

class AddRate extends StatefulWidget {
  AddRate({
    Key? key,
  }) : super(key: key) {}

  @override
  State<AddRate> createState() => _AddRateState();
}

class _AddRateState extends State<AddRate> {
  String? commentText;
  double _currentRating = 0;
  String _textError = "";
  void writeComment() {
    print(commentText);
    print(_currentRating);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Text(
                'Dodaj ocenu',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Color.fromARGB(255, 100, 120, 254),
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _currentRating = rating;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 7, 5, 10),
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                        'https://www.unmc.edu/cihc/_images/faculty/default.jpg'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: 'Dodaj komentar...',
                      ),
                      onChanged: (value) {
                        setState(() {
                          commentText = value;
                        });
                      },
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
              child: Text(
                _textError,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(75, 10, 10, 10),
                  child: SizedBox(
                    height: 35,
                    width: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          primary: Color.fromARGB(255, 100, 120, 254),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Nazad',
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 75, 10),
                  child: SizedBox(
                    height: 35,
                    width: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        primary: Color.fromARGB(255, 100, 120, 254),
                      ),
                      onPressed: () {
                        if (_currentRating > 0) {
                          writeComment();
                          Navigator.pop(
                            context,
                            ReviewModel(
                                profileImage:
                                    "https://lh3.googleusercontent.com/ogw/ADea4I6uQeJPyoCB5xCXF5eKxHM_NEKnu6V0iE__X4fA=s64-c-mo", //TO DO treba da se ucita sa globalnog stora
                                fullName: "Marija Krsanin",
                                rate: _currentRating,
                                commentText: commentText),
                          );
                        } else {
                          setState(() {
                            _textError = "Morate ostaviti ocenu!";
                          });
                        }
                      },
                      child: const Text('Dodaj'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
