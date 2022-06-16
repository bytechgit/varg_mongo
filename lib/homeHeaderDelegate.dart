import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moj_majstor/CategoryItem.dart';
import 'package:moj_majstor/filter.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  double toolBarHeight;
  double closedHeight;
  double openHeight;

  final filterController = Get.find<Filter>();
  HomeHeaderDelegate({
    this.toolBarHeight = 0,
    this.closedHeight = 0,
    required this.openHeight,
  });

  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: toolBarHeight + openHeight,
      color: Colors.white,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 236, 236),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.search,
                                size: 30,
                                color: Color.fromARGB(255, 121, 121, 121),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: TextField(
                                controller: filterController.searchcontroller,
                                // storeController.reviewNameController,
                                style: TextStyle(fontSize: 20),
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search'),
                              ),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 236, 236),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: Icon(
                            Icons.tune,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          child: SizedBox(
                            width: 90,
                            height: 90,
                            child: Obx(
                              () => Column(
                                children: [
                                  if (filterController.categoryIcon.value != '')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Obx(
                                        () => Image(
                                          width: 50,
                                          image: AssetImage(filterController
                                              .categoryIcon.value),
                                        ),
                                      ),
                                    ),
                                  Expanded(child: Container()),
                                  if (filterController.category.value != '')
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, left: 5, right: 5),
                                        child: FittedBox(
                                          child: Obx(
                                            () => Text(filterController
                                                .category.value),
                                          ),
                                        ))
                                ],
                              ),
                            ),
                          ),
                          color: Color.fromARGB(255, 217, 222, 255),
                          elevation: 4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            CategoryItem(
                              icon: 'assets/img/kategorija1.png',
                              category: 'Elektricar',
                            ),
                            CategoryItem(
                              icon: 'assets/img/kategorija1.png',
                              category: 'Vodoinstalater',
                            ),
                            CategoryItem(
                              icon: 'assets/img/kategorija2.png',
                              category: 'Odzacar',
                            ),
                            CategoryItem(
                              icon: 'assets/img/kategorija1.png',
                              category: 'Bastovan',
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => toolBarHeight + openHeight;

  @override
  double get minExtent => toolBarHeight + closedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
