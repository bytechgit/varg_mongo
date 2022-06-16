import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moj_majstor/Authentication.dart';

class SignUpUser extends StatefulWidget {
  const SignUpUser({Key? key}) : super(key: key);

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool show_password = true;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final citycontroller = TextEditingController();
  final streetaddresscontroller = TextEditingController();
  UserAuthentication ua = UserAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 144, 159, 254),
            pinned: true,
            expandedHeight: 230.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 20),
              title: Text('Registracija'),
              background: Container(
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
                child: const Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Color.fromARGB(183, 100, 121, 254),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: namecontroller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Ime i prezieme",
                            prefixIcon: Icon(Icons.people),
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(
                                  errorText: "Unesite ime i prezime"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: citycontroller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Grad",
                            prefixIcon: Icon(Icons.people),
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Unesite grad"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: streetaddresscontroller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Ulica i broj",
                            prefixIcon: Icon(Icons.people),
                          ),
                          // validator: MultiValidator(
                          // [
                          //RequiredValidator(errorText: "Unesite ulicu i broj"),
                          // ],
                          //   ),
                        ),
                      ),
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
                              RequiredValidator(errorText: "Unsite email"),
                              EmailValidator(
                                  errorText: "Unesite validan email"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: passwordcontroller,
                          obscureText: show_password,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => {
                                      setState(
                                        () => {
                                          show_password = !show_password,
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
                              //RequiredValidator(errorText: ""),
                              MinLengthValidator(8,
                                  errorText:
                                      "Lozinka mora imati najmanje 8 karaktera"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 144, 159, 254),
                                elevation: 5),
                            onPressed: () async {
                              if (formkey.currentState?.validate() == true) {
                                // String result = await ua.signUp(
                                //     email: emailcontroller.text,
                                //     password: passwordcontroller.text,
                                //     fullName: namecontroller.text,
                                //     city: citycontroller.text,
                                //     streetAddress:
                                //         streetaddresscontroller.text);
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text(result)));
                              }
                            },
                            child: Center(
                                child: Text(
                              'Kreirej nalog'.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
