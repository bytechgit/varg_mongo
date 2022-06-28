import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:moj_majstor/LocalDatabase.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'package:moj_majstor/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'messageControler.dart';
import 'messageList.dart';

class UserAuthentication with ChangeNotifier {
  static final UserAuthentication _singleton = UserAuthentication._internal();

  StreamController<String> Events = StreamController.broadcast();
  factory UserAuthentication() {
    return _singleton;
  }
  LocalDatabase l = LocalDatabase();
  late Future<void> _hive;
  UserData? user;
  String _verificationCode = '000000';
  UserAuthentication._internal() {
    _hive = initializeHive().then((value) {
      getUserFromLocalDb().then((value) {
        user = value;
        notifyListeners();
      });
    });
  }
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  UserData? get currentUser {
    if (user != null) {
      return user;
    }
    getUserFromLocalDb().then((value) {
      user = value;
      if (user != null) {
        return user;
      }
    });
    return null;
  }

  Future<void> signout() async {
    Events.add("SignOut");
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    user = null;
    saveUserToLocalDb(null);
  }

  Future<String> signInwithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ["email", "public_profile"]);
      switch (result.status) {
        case LoginStatus.success:
          final response1 = await http.get(Uri.parse(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken!.token}'));
          final profile = jsonDecode(response1.body);
          print(profile);
          final response = await http.post(
            Uri.parse('http://100.101.167.63:3000/facebookLogin'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'token': result.accessToken!.token}),
          );
          if (response.statusCode == 200) {
            user = UserData.fromMap(jsonDecode(response.body));
          } else if (response.statusCode == 201) {
            print(jsonDecode(response.body));
            user = UserData.fromMap(jsonDecode(response.body));
            //novi user
            //treba da unese dodatni podaci
          }

          saveUserToLocalDb(user);

          Events.add("SignIn");

          return 'Uspesna prijava';
        case LoginStatus.cancelled:
          return 'Prijava otkazana'; //Resource(status: Status.Cancelled);
        case LoginStatus.failed:
          return 'Neuspela prijava'; //Resource(status: Status.Error);
        default:
          return 'Greska';
      }
    } on Exception catch (e) {
      return 'Gresaka, pokusajte ponovo!';
    }
  }

  void signInwithPhoneNumberCode(String code) {
    try {
      //  _auth.signInWithCredential(PhoneAuthProvider.credential(
      //  verificationId: _verificationCode, smsCode: code));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> sendCodeToPhoneNumber(String phoneNumber) async {
    // try {
    //   await _auth.verifyPhoneNumber(
    //     phoneNumber: phoneNumber,
    //     verificationCompleted: (PhoneAuthCredential credential) async {
    //       await _auth.signInWithCredential(credential);
    //     },
    //     verificationFailed: (FirebaseAuthException e) {
    //       if (e.code == 'invalid-phone-number') {
    //         print('The provided phone number is not valid.');
    //       }
    //     },
    //     codeSent: (String verificationId, int? resendToken) async {
    //       _verificationCode = verificationId;
    //     },
    //     codeAutoRetrievalTimeout: (String verificationId) {
    //       _verificationCode = verificationId;
    //     },
    //   );
    // } on FirebaseAuthException catch (e) {
    //   //return e.message ?? 'Greska, pokusajte ponovo';
    //   print(e.message);
    // } on Exception catch (e) {
    //   // return 'Gresaka, pokusajte ponovo!';
    // }
  }

  Future<String> signInwithGoogle() async {
    signout();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        print(credential.idToken);
        final response = await http.post(
          Uri.parse('http://100.101.167.63:3000/googleLogin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'token': credential.idToken}),
        );
        if (response.statusCode == 200) {
          user = UserData.fromMap(jsonDecode(response.body));
          saveUserToLocalDb(user);
          Events.add("SignIn");

          return 'Uspesno ste prijavljeni!';
        } else {
          return 'Greska, pokusajte ponovo';
        }
      }
      return 'Greska, pokusajte ponovo';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/Register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'user': UserData(UID: 'wwwwwww', fullName: 'dddddd').toMap()
        }),
      );
      if (response.statusCode == 200) {
        user = UserData.fromMap(jsonDecode(response.body));
        Events.add("SignIn");
        return 'Uspesno ste prijavljeni';
      } else {
        inspect(response);
        return 'Greska, pokusajte ponovo';
      }
    } catch (e) {
      return 'Greska, pokusajte ponovo';
    }
  }

  Future<String> signUp({
    required UserData user,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://100.101.167.63:3000/SignUp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'user': user}),
      );
      if (response.statusCode == 200) {
        user = UserData.fromMap(jsonDecode(response.body));
        return 'Na vasu email adresu je poslat link za verifikaciju';
      } else {
        return 'Greska, pokusajte ponovo';
      }
    } catch (e) {
      return 'Greska, pokusajte ponovo';
    }
  }

  Future<http.Response> addUser(MajstorModel majstor) {
    return http.post(
      Uri.parse('http://100.101.167.63:3000/addUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(majstor.toMap()),
    );
  }

  Future<MajstorModel> getUser(String UID) async {
    final response =
        await http.get(Uri.parse('http://100.79.156.38:3000/getUser/' + UID));

    if (response.statusCode == 200) {
      return MajstorModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  ///hive
  ///
  ///
  Future<void> initializeHive() async {
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    Hive.registerAdapter(UserDataAdapter(), override: true);
  }

  Future<void> saveUserToLocalDb(UserData? user) async {
    await _hive;
    var userBox = await Hive.openBox('userBox');
    await userBox.put('profile', user);
  }

  Future<UserData?> getUserFromLocalDb() async {
    await _hive;
    var userBox = await Hive.openBox('userBox');
    return userBox.get('profile');
  }
}
