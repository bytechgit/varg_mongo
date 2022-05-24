import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_majstor/Authentication.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneLogin extends StatefulWidget {
  final String phoneNumber;

  //final String phoneNumber;

  const PhoneLogin({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  final Color purpleColor = Color.fromARGB(255, 144, 159, 254);
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  UserAuthentication ua = UserAuthentication();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.b.primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => {Navigator.pop(context)},
                icon: Icon(
                  Icons.arrow_back,
                  color: purpleColor,
                  size: 24,
                ),
              ),
            ),
            // const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    child: Image.asset('assets/img/Enter OTP-pana.png'),
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Verifikacija ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "Unesite kod poslat na broj ",
                    children: [
                      TextSpan(
                          text: "${widget.phoneNumber}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: purpleColor,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: true,
                    obscuringCharacter: '*',
                    // obscuringWidget: const FlutterLogo(
                    //   size: 24,
                    // ),
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        inactiveColor: purpleColor,
                        activeColor: purpleColor,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        selectedColor: purpleColor,
                        inactiveFillColor: Colors.white),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                hasError ? "*Popunite sva polja" : "",
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Niste dobili kod? ",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                TextButton(
                  onPressed: () => snackBar("Kod je ponovo poslat"),
                  child: Text(
                    //moze neko odbrojavanje 60 sekundi pa tad da se dobije opsija za resend
                    "POSALJI PONOVO",
                    style: TextStyle(
                        color: purpleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Container(
              height: 45,
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: purpleColor, elevation: 5),
                onPressed: () {
                  //formKey.currentState!.validate();
                  if (currentText.length != 6) {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                    //ua.sendCodeToPhoneNumber(widget.phoneNumber);
                    ua.signInwithPhoneNumberCode(currentText);
                  } else {
                    setState(
                      () {
                        hasError = false;
                        snackBar("OTP Verified!!");
                      },
                    );
                  }
                },
                child: Center(
                    child: Text(
                  "VERIFIKUJ".toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
