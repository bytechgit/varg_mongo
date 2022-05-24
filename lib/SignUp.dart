import 'package:flutter/material.dart';
import 'package:moj_majstor/SignUpMajstor.dart';
import 'package:moj_majstor/SignUpUser.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  int _selectedIndex = 0;
  final PageController pageController = PageController();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _pageViewChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Majstor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Korisnik',
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (index) {
          _pageViewChange(index);
        },
        controller: pageController,
        children: const <Widget>[
          SignUpUser(),
          SignUpMajstor(),
        ],
      ),
    );
  }
}
