import 'package:flutter/material.dart';
import 'package:moj_majstor/ShimmerElement.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 5; i++) ShimmerElement(),
      ],
    );
  }
}
