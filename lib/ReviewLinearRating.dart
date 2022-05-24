import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moj_majstor/ReviewProgressBar.dart';

class ReviewRating extends StatefulWidget {
  const ReviewRating({Key? key}) : super(key: key);

  @override
  State<ReviewRating> createState() => _ReviewRatingState();
}

class _ReviewRatingState extends State<ReviewRating> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10.0, top: 25, left: 10, right: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
            //width: 300,

            //color: Colors.amber,
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: Text(
                'Customer reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              // color: Color.fromARGB(255, 201, 201, 201),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color.fromARGB(255, 236, 236, 236),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 3, bottom: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingBarIndicator(
                      rating: 4.2,
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
                      child: Text('4.2 od 5'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 5),
              child: Text('120 ocena korisnika'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: Divider(
                thickness: 2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ReviewProgressBar(
              text: '5 zvezdice',
            ),
            ReviewProgressBar(
              text: '4 zvezdice',
            ),
            ReviewProgressBar(
              text: '3 zvezdice',
            ),
            ReviewProgressBar(
              text: '2 zvezdice',
            ),
            ReviewProgressBar(
              text: '1 zvezdica',
            ),
            SizedBox(
              height: 20,
            )
          ],
        )),
      ),
    );
  }
}
