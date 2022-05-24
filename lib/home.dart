import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moj_majstor/InternetConnection.dart';
import 'package:moj_majstor/Login.dart';
import 'package:moj_majstor/PhoneLogin.dart';
import 'package:moj_majstor/Profil.dart';
import 'package:moj_majstor/proba.dart';
import 'package:overlay_support/overlay_support.dart';
import 'PhoneNumber.dart';
import 'SignUpUser.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final InternetConnection _connection = InternetConnection();
  int _selectedIndex = 0;
  Widget current = proba();
  List<Widget> screens = [
    proba(),
    Login(),
    proba(),
    Profil(),
  ];
  final PageController pageController = PageController();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      current = screens[index];
    });
  }

  var maj = [
    {
      'ime': 'Milan Raškovic',
      'slika': 'assets/img/radnik.jpg',
      'ocena': '10',
    },
    {'ime': 'Milan Raškovic', 'slika': 'assets/img/radnik.jpg', 'ocena': '10'},
    {
      'ime': 'Zeljko Stepanovic',
      'slika': 'assets/img/radnik.jpg',
      'ocena': '10',
    },
    {
      'ime': 'Lazar Velimirović',
      'slika': 'assets/img/radnik.jpg',
      'ocena': '10',
    },
    {
      'ime': 'Aleksandar Mijujkić',
      'slika': 'assets/img/radnik.jpg',
      'ocena': '10',
    },
    {'ime': 'Ivan Stepanovic', 'slika': 'assets/img/radnik.jpg', 'ocena': '10'},
    {
      'ime': 'Igor Juricic',
      'slika': 'assets/img/radnik.jpg',
      'ocena': '10',
    },
    {
      'ime': 'Александар Николић',
      'slika': 'assets/img/radnik.jpg',
      'ocena': '10',
    },
  ];
  double _height = 100;
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Color.fromARGB(255, 100, 120, 254),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.call),
                label: 'Pocetna',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: 'Pretraga',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: 'Korisnik',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: 'Profil',
              ),
            ],
          ),
          body: current,
        ),
      ),
    );
  }
}
