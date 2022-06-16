import 'dart:developer';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:moj_majstor/ForgotPassword.dart';
import 'package:moj_majstor/LocalDatabase.dart';
import 'package:moj_majstor/PhoneNumber.dart';
import 'package:moj_majstor/SignUp.dart';
import 'package:moj_majstor/messageControler.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'package:moj_majstor/models/User.dart';
import 'package:moj_majstor/models/message.dart';
import 'package:moj_majstor/mongo.dart';
import 'Authentication.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moj_majstor/Notification.dart' as FCM;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserAuthentication ua = UserAuthentication();
  final messageController = Get.find<messageControler>();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool showPassword = true;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 100, 121, 254),
                        Color.fromARGB(255, 144, 159, 254),
                      ],
                    ),
                  ),
                  height: 300,
                  // color: const Color.fromRGBO(255, 152, 0, 1),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 160, left: 30),
                        child: Text(
                          'Dobro dosli',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 43, color: Colors.white),
                        ),
                      ),
                      SafeArea(
                        child: IconButton(
                          onPressed: () => {Navigator.pop(context)},
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: formkey,
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailcontroller,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Email",
                          prefixIcon: Icon(Icons.people),
                        ),
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "Unesite email"),
                            EmailValidator(
                                errorText: "Unesite validnu email adresu"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                        controller: passwordcontroller,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => {
                                    setState(
                                      () => {
                                        showPassword = !showPassword,
                                      },
                                    )
                                  },
                              icon: Icon(Icons.remove_red_eye)),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Password",
                          prefixIcon: Icon(Icons.people),
                        ),
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "Unesite lozinku"),
                            MinLengthValidator(6,
                                errorText:
                                    "Lozinka mora imati najmanje 8 karaktera"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 144, 159, 254),
                      elevation: 5),
                  onPressed: () async {
                    if (formkey.currentState?.validate() == true) {
                      String result = await ua.login(
                          email: emailcontroller.text,
                          password: passwordcontroller.text);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(result)));
                    }
                  },
                  child: Center(
                      child: Text(
                    "Login",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: RichText(
                  text: TextSpan(
                    //style: defaultStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'FORGOT PASSWORD ?',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const ForgotPassword();
                              }),
                            );
                          },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 100, 120, 254),
                            fontFamily: 'Century'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: const Image(
                      width: 50,
                      image: AssetImage('assets/img/google.png'),
                    ),
                    onTap: () async {
                      // ua.signInwithPhoneNumber();
                      String result = await ua.signInwithGoogle();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(result)));
                    },
                  ),
                  //  Text(ua.getname() ?? 'nema'),
                  // Image.network(ua.getImage()),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: InkWell(
                      child: const Image(
                        width: 50,
                        image: AssetImage('assets/img/facebook.png'),
                      ),
                      onTap: () async {
                        // ua.signInwithFacebook();

                        String result = await ua.signInwithFacebook();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(result)));
                      },
                    ),
                  ),
                  InkWell(
                    child: const Image(
                      width: 50,
                      image: AssetImage('assets/img/phonelog.png'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const PhoneNumber();
                        }),
                      );
                    },
                  ),
                ],
              ),
              //const (child: SizedBox()),
              // const Flexible(child: SizedBox(), fit: FlexFit.tight),

              //Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: RichText(
                  text: TextSpan(
                    //style: defaultStyle,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'New User?  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 100, 120, 254)),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const SignIn();
                              }),
                            );
                          },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 100, 120, 254)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
