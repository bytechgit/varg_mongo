import 'package:flutter/material.dart';
import 'package:moj_majstor/Majsor.dart';

class SignUpMajstor extends StatefulWidget {
  const SignUpMajstor({Key? key}) : super(key: key);

  @override
  State<SignUpMajstor> createState() => _SignUpMajstorState();
}

class _SignUpMajstorState extends State<SignUpMajstor> {
  var kat = [
    {'naziv': 'Elektricar', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Vodoinstalater', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Majstor', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Televizor', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Elektricar', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Vodoinstalater', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Majstor', 'slika': 'assets/img/elektricar.png'},
    {'naziv': 'Televizor', 'slika': 'assets/img/elektricar.png'},
  ];
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Expanded(
              child: ListView(
                  // padding: EdgeInsets.only(left: 10, right: 10),
                  //childAspectRatio: 5 / 2,
                  // children: maj.map((e) {
                  //   return Majstor(
                  //     slika: e['slika'] ?? '',
                  //     ime: e['ime'] ?? '',
                  //     ocena: e['ocena'] ?? '',
                  //   );
                  // }).toList(),
                  // children: [
                  //   Container(
                  //     height: 20,
                  //     child: Card(
                  //       color: Colors.red,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20.0),
                  //       ),
                  //       shadowColor: Colors.black,
                  //       elevation: 10,
                  //       child: Column(
                  //         children: [
                  //           //  Spacer(),
                  //           Expanded(
                  //             child: Padding(
                  //               padding: const EdgeInsets.only(top: 8.0),
                  //               child: Image(
                  //                 image: AssetImage('assets/img/elektricar.png'),
                  //               ),
                  //             ),
                  //           ),
                  //           FittedBox(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(20.0),
                  //               child: Text(
                  //                 "Elektricar",
                  //                 style:
                  //                     TextStyle(fontSize: 25, color: Colors.white),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  //   Card(
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     shadowColor: Colors.black,
                  //     elevation: 10,
                  //   ),
                  //   Card(
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     shadowColor: Colors.black,
                  //     elevation: 10,
                  //   ),
                  //   Card(
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     shadowColor: Colors.black,
                  //     elevation: 10,
                  //   ),
                  //   Card(
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     shadowColor: Colors.black,
                  //     elevation: 10,
                  //   ),
                  //   Card(
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     shadowColor: Colors.black,
                  //     elevation: 10,
                  //   ),
                  //   Card(
                  //     color: Colors.red,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     shadowColor: Colors.black,
                  //     elevation: 10,
                  //   ),
                  // ],
                  //crossAxisCount: 1,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
