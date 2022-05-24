import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/Majstor.dart';

class Filter extends GetxController {
  DocumentSnapshot<Object?>? lastReadedDoc;
  final _firestore = FirebaseFirestore.instance;
  var majstori = [].obs;
  var category = 'vodoinstalater'.obs;
  var categoryIcon = ''.obs;
  var sortBy = 'Popularnost'.obs;
  String? city = 'Leskovac';
  final searchcontroller = TextEditingController();
  void handleSortByChange(String? value) {
    sortBy(value.toString());
  }

  Future<int> search() async {
    final readedDoc = (await _firestore
        .collection("Users")
        .where('primaryOccupation', isEqualTo: category.value)
        .where('city', isEqualTo: city)
        // .orderBy("score")
        .limit(1)
        .get());
    majstori.clear();
    for (var document in readedDoc.docs) {
      majstori.add(MajstorModel.fromMap(document.data()));
    }
    if (readedDoc.docs.isNotEmpty) {
      lastReadedDoc = readedDoc.docs.last;
    }
    return readedDoc.docs.length;
  }

  Future<int> loadMore() async {
    if (lastReadedDoc == null) {
      final newDocumentList = (await _firestore
          .collection("Users")
          .where('primaryOccupation', isEqualTo: category.value)
          .where('city', isEqualTo: city)
          .orderBy(sortBy)
          .limit(2)
          .get());
      for (var document in newDocumentList.docs) {
        majstori.add(MajstorModel.fromMap(document.data()));
      }
      if (newDocumentList.docs.isNotEmpty) {
        lastReadedDoc = newDocumentList.docs.last;
      }
      return newDocumentList.docs.length;
    } else {
      final newDocumentList = (await _firestore
          .collection("Users")
          .where('primaryOccupation', isEqualTo: category.value)
          .where('city', isEqualTo: city)
          // .orderBy("score")
          .startAfterDocument(lastReadedDoc!)
          .limit(3)
          .get());
      for (var document in newDocumentList.docs) {
        majstori.add(MajstorModel.fromMap(document.data()));
      }
      if (newDocumentList.docs.isNotEmpty) {
        lastReadedDoc = newDocumentList.docs.last;
      }
      return newDocumentList.docs.length;
    }
  }
}
