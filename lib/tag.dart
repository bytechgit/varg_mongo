import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  const Tag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5, bottom: 5),
      child: Chip(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        label: Text(
          text,
          style: TextStyle(
              fontSize: 15, color: Color.fromARGB(255, 131, 131, 131)),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
