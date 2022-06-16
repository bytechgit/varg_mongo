import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moj_majstor/models/Comment.dart';
import 'package:moj_majstor/models/ReviewModel.dart';

class Review extends StatelessWidget {
  //late double mark;

  late Comment _model;

  Review({
    Key? key,
    required Comment model,
  }) : super(key: key) {
    _model = model;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(_model.profile_pictrue),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
                          child: Text(
                            _model.author_name,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 7, 10.0, 10),
                          child: RatingBarIndicator(
                            rating: _model.rate,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                    child: Text(_model.created_at),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              thickness: 1,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 5.0, 20.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                _model.text,
                // _model.commentText ??
                //    " ", //treba dodati sta se desava ako nema tekst komentara
                style: const TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
