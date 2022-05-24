import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:moj_majstor/LocalDatabase.dart';
import 'package:moj_majstor/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserAuthentication with ChangeNotifier {
  static final UserAuthentication _singleton = UserAuthentication._internal();
  factory UserAuthentication() {
    return _singleton;
  }
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? streamSubUser;
  late StreamSubscription<User?> userChanges;
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
    _initializeFirebase();
    userChanges = _auth.userChanges().listen((event) {
      if (event != null) {
        UserChanges(event.uid);
      } else {
        user = null;
        saveUserToLocalDb(null);
      }
      notifyListeners();
    });
  }
  @override
  void dispose() {
    userChanges.cancel();
    streamSubUser?.cancel();
    super.dispose();
  }

  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase',
    ],
  );
  UserData? get currentUser {
    if (user != null) {
      return user;
    }
    getUserFromLocalDb().then((value) {
      user = value;
      if (user != null) {
        notifyListeners();
      }
    });
    return null;
  }

  Future<void> signout() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }

  Future<String> signInwithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ["email", "public_profile"]);
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userObj = await _auth.signInWithCredential(facebookCredential);
          if (userObj.user != null) {
            if (userObj.additionalUserInfo?.isNewUser == true) {
              _addUser(
                  uid: userObj.user!.uid,
                  fullName: userObj.user!.providerData[0].displayName ?? '',
                  city: null,
                  streetAddress: null,
                  profilePicture: userObj.user!.providerData[0].photoURL);
            }
            return 'Uspesna prijava';
          }
          return 'Greska'; //Resource(status: Status.Success);
        case LoginStatus.cancelled:
          return 'Prijava otkazana'; //Resource(status: Status.Cancelled);
        case LoginStatus.failed:
          return 'Neuspela prijava'; //Resource(status: Status.Error);
        default:
          return 'Greska';
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Greska, pokusajte ponovo';
    } on Exception catch (e) {
      return 'Gresaka, pokusajte ponovo!';
    }
  }

  void signInwithPhoneNumberCode(String code) {
    try {
      _auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: _verificationCode, smsCode: code));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> sendCodeToPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationCode = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationCode = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      //return e.message ?? 'Greska, pokusajte ponovo';
      print(e.message);
    } on Exception catch (e) {
      // return 'Gresaka, pokusajte ponovo!';
    }
  }

  Future<String> signInwithGoogle() async {
    signout();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        //final googleAuth = await googleSignInAccount.authentication;
        UserCredential uc = await _auth.signInWithCredential(credential);
        if (uc.user != null) {
          if (uc.additionalUserInfo?.isNewUser == true) {
            _addUser(
                uid: uc.user!.uid,
                fullName: uc.user!.providerData[0].displayName ?? '',
                city: null,
                streetAddress: null,
                profilePicture: uc.user!.providerData[0].photoURL);
          }
        }
        notifyListeners();
        return 'Uspesno ste prijavljeni!';
      }
      return 'Greska, pokusajte ponovo';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Greska';
    } on Exception catch (e) {
      return 'Gresaka, pokusajte ponovo!';
    }
  }

  Future<String> Login(
      {required String email, required String password}) async {
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Uspesno ste prijavljeni';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Greska, pokusajte ponovo';
    } catch (e) {
      return 'Greska, pokusajte ponovo';
    }
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String fullName,
    required String city,
    required String streetAddress,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        userCredential.user!.sendEmailVerification();
        _addUser(
            uid: userCredential.user!.uid,
            fullName: fullName,
            city: city,
            streetAddress: streetAddress);
      }
      return 'Na vasu email adresu je poslat link za vrerifikaciju';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Greska, pokusajte ponovo';
    } catch (e) {
      return 'Greska, pokusajte ponovo';
    }
  }

  Future<void>? _addUser({
    required String uid,
    required String fullName,
    String? city,
    String? streetAddress,
    String? profilePicture,
  }) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          'UID': uid,
          'fullName': fullName,
          'city': city,
          'streetAddress': streetAddress,
          'profilePicture': profilePicture,
          'occupation': []
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<UserData> GetUser(String UID) async {
    final p =
        await firestore.collection('Users').where('UID', isEqualTo: UID).get();
    UserData u = UserData.fromMap(p.docs.first.data());

    return u;
  }

  // void UserChanges(String UID) {
  //   if (streamSubUser != null) {
  //     streamSubUser!.cancel();
  //   }
  //   streamSubUser = firestore
  //       .collection("Users")
  //       .doc(UID)
  //       .snapshots()
  //       .listen((result) async {
  //     {
  //       if (result.data() != null) {
  //         UserData ud = UserData.fromMap(result.data()!);
  //         await l.insertUser(ud);
  //         inspect(await l.GetUser());
  //       }
  //     }
  //   });
  // }

  void UserChanges(String UID) {
    if (streamSubUser != null) {
      streamSubUser!.cancel();
    }
    streamSubUser = firestore
        .collection("Users")
        .doc(UID)
        .snapshots()
        .listen((result) async {
      {
        if (result.data() != null) {
          saveUserToLocalDb(UserData.fromMap(result.data()!));
          user = UserData.fromMap(result.data()!);
          notifyListeners();
        }
      }
    });
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
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
