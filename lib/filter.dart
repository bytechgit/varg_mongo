import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'models/Majstor.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

class Filter extends GetxController {
  var majstori = [].obs;
  var category = 'vodoinstalater'.obs;
  var categoryIcon = ''.obs;
  var sortBy = 'Popularnost'.obs;
  String? city = '';
  int skip = 0;
  final searchcontroller = TextEditingController();
  void handleSortByChange(String? value) {
    sortBy(value.toString());
  }

  Future<int> get(bool first) async {
    int pomskip = skip;
    try {
      if (first == true) {
        majstori.clear();
        skip = 0;
      }
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/getUsers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'skip': skip,
          'city': city,
          'limit': 10,
          'primaryOccupation': category.value
        }),
      );
      if (response.statusCode == 200) {
        for (var m in jsonDecode(response.body)) {
          {
            majstori.add(MajstorModel.fromMap(m));
            skip++;
          }
        }
      }
      return skip - pomskip;
    } catch (e) {
      return 0;
    }
  }
}
