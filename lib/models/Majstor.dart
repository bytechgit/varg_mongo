import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/models/Comment.dart';

class MajstorModel {
  UserAuthentication ua = UserAuthentication();
  int loadedComments = 0;
  String UID;
  String? city;
  String fullName;
  String? streetAddress;
  String? phoneNumber;
  List<String>? occupation;
  String? bio;
  double? rate;
  int? reviewsNumber;
  int? recommendationNumber;
  String? profilePicture;
  String? primaryOccupation;
  List<Comment> comments = [];
  List<String> likes = [];

  MajstorModel(
      {required this.UID,
      this.city,
      required this.fullName,
      this.streetAddress,
      this.phoneNumber,
      this.occupation,
      this.bio,
      this.rate = 0,
      this.reviewsNumber,
      this.recommendationNumber,
      this.profilePicture,
      this.primaryOccupation});
  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'fullName': fullName,
      'city': city,
      'streetAddress': streetAddress,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'rate': rate,
      'reviewsNumber': reviewsNumber,
      'bio': bio,
      'recommendationNumber': recommendationNumber,
      'profilePicture': profilePicture,
      'primaryOccupation': primaryOccupation
    };
  }

  Future<bool> addComment(Comment c) async {
    try {
      if (ua.currentUser != null) {
        comments.add(c);
        final response = await http.post(
          Uri.parse('http://100.101.167.63:3000/addComment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'comment': c.toMap(),
          }),
        );
        if (response.statusCode == 200) {
          //dobro je
          return true;
        }
        return false;
      } else {
        Get.snackbar('Niste prijavljeni', 'Niste prijavljeni',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addLike(bool liked) async {
    try {
      if (ua.currentUser != null) {
        if (!liked) {
          likes.add(ua.currentUser!.UID);
        } else {
          likes.remove(ua.currentUser!.UID);
        }
        final response = await http.post(
          Uri.parse('http://100.101.167.63:3000/changeLike'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'uid': ua.currentUser!.UID,
            'likedUid': UID,
            'isLiked': liked,
          }),
        );
        if (response.statusCode == 200) {
          //dobro je
          return true;
        }
        return false;
      } else {
        Get.snackbar('Niste prijavljeni', 'Niste prijavljeni',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToFavorites(bool isInFavorites) async {
    try {
      if (ua.currentUser != null) {
        if (!isInFavorites) {
          ua.currentUser!.favorites?.add(UID);
        } else {
          ua.currentUser!.favorites?.remove(UID);
        }
        final response = await http.post(
          Uri.parse('http://100.101.167.63:3000/changeFavorite'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'uid': ua.currentUser!.UID,
            'favuid': UID,
            'isInFavorites': isInFavorites
          }),
        );
        if (response.statusCode == 200) {
          //dobro je
          return true;
        }
        return false;
      } else {
        Get.snackbar('Niste prijavljeni', 'Niste prijavljeni',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool isInFavorites() {
    if (ua.currentUser != null) {
      if (ua.currentUser!.favorites != null) {
        if (ua.currentUser!.favorites!.contains(UID)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isLiked() {
    if (ua.currentUser != null) {
      if (likes.contains(ua.currentUser!.UID)) {
        return true;
      }
    }
    return false;
  }

  Future<int> getComments() async {
    int pomskip = loadedComments;
    try {
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/getComments'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'skip': loadedComments,
          'limit': 10,
        }),
      );
      if (response.statusCode == 200) {
        for (var c in jsonDecode(response.body)) {
          {
            comments.add(Comment.fromMap(c));
            loadedComments++;
          }
        }
      }
      return loadedComments - pomskip;
    } catch (e) {
      return 0;
    }
  }

  MajstorModel.fromMap(Map<String, dynamic> map)
      : UID = map["UID"],
        city = map["city"],
        fullName = map["fullName"],
        streetAddress = map["streetAddress"],
        phoneNumber = map["phoneNumber"],
        occupation = (((map["occupation"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList()),
        bio = map["bio"],
        rate = ((map["rate"]) ?? 0).toDouble(),
        reviewsNumber = map["reviewsNumber"],
        recommendationNumber = map["recommendationNumber"],
        profilePicture = map["profilePicture"],
        primaryOccupation = map["primaryOccupation"],
        likes = (((map["likes"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList());
}
