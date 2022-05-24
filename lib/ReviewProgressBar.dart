import 'package:flutter/material.dart';

class ReviewProgressBar extends StatefulWidget {
  String text;
  ReviewProgressBar({Key? key, required this.text}) : super(key: key);

  @override
  State<ReviewProgressBar> createState() => _ReviewProgressBarState();
}

class _ReviewProgressBarState extends State<ReviewProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 10),
          child: Text(widget.text),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: 150,
            height: 15,
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: 0.9,
                valueColor:
                    AlwaysStoppedAnimation(Color.fromARGB(255, 252, 219, 71)),
                backgroundColor: Color(0xffD6D6D6),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 30),
          child: Text('93%'),
        ),
      ],
    );
  }
}
