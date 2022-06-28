import 'package:flutter/material.dart';
import 'package:moj_majstor/Authentication.dart';
import 'package:moj_majstor/PhoneLogin.dart';
import 'package:provider/provider.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController phoneNumber = TextEditingController(text: "+381 ");
  @override
  Widget build(BuildContext context) {
    final ua = Provider.of<UserAuthentication>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => {Navigator.pop(context)},
                icon: Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 144, 159, 254),
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    child: Image.asset('assets/img/Messages.png'),
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            // Expanded(child: Container()),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SMS Verifikacija',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 30, right: 30, bottom: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Poslacemo vam jednokratnu lozinku na broj telefona',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(112, 124, 128, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneNumber,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 144, 159, 254),
                          elevation: 5),
                      onPressed: () {
                        //formKey.currentState!.validate();
                        //neka validacija da se doda
                        ua.sendCodeToPhoneNumber(phoneNumber.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return PhoneLogin(
                              phoneNumber: phoneNumber.text,
                            );
                          }),
                        );
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
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
