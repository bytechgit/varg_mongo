import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  color: Colors.red,
        body: SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/img/Reset_password.png"),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Text(
                  'Zaboravili ste lozinku?',
                  style: TextStyle(
                      fontSize: 30, color: Color.fromARGB(255, 100, 120, 254)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text(
                  'Unesite email adresu povezanu sa vasim nalogom',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width * 0.85,
                child: const TextField(

                    //controller: username,

                    decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Email",
                  prefixIcon: Icon(Icons.people),
                )),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                height: 45,
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(183, 100, 121, 254),
                      elevation: 5),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Na vasu email adresu je poslat link za izmenu lozinke')));
                  },
                  child: Center(
                      child: Text(
                    "Resetuj lozinku",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
