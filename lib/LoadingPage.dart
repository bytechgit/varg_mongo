import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_majstor/InternetConnection.dart';
import 'package:moj_majstor/Login.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  InternetConnection network = InternetConnection();

  void LoadPage() {
    network.testConnection();
    if (InternetConnection.isDeviceConnected) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const Login();
      }), (Route<dynamic> route) => false);
    } else {
      Timer(const Duration(seconds: 2), LoadPage);
    }
  }

  @override
  initState() {
    super.initState();
    Timer(const Duration(seconds: 2), LoadPage);
  }

  @override
  dispose() {
    super.dispose();
    // subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(230, 230, 230, 1)),
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: const AssetImage('assets/img/logo.png'),
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                      child: Text(
                        'MADE BY BYTECH',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
