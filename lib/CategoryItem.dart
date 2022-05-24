import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'AppState.dart';
import 'filter.dart';

class CategoryItem extends StatelessWidget {
  final Color color;
  final String icon;
  final String category;
  final filterController = Get.find<Filter>();
  CategoryItem(
      {Key? key,
      this.color = Colors.white,
      required this.icon,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return InkWell(
      onTap: () {
        filterController.category.value = category;
        filterController.categoryIcon.value = icon;
        inspect(filterController);
      },
      child: Card(
        child: SizedBox(
          width: 90,
          height: 90,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image(
                  width: 50,
                  image: AssetImage(icon),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 5, right: 5),
                child: FittedBox(child: Text(category)),
              )
            ],
          ),
        ),
        color: color,
        elevation: 4,
      ),
    );
  }
}
