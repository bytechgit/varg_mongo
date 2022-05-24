import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final followerCount = 0.obs;
  final searchcontroller = TextEditingController();
  updateFollowerCount() {
    followerCount(followerCount.value + 10);
  }
}
