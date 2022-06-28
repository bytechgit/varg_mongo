// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moj_majstor/InsertLocation.dart';
import 'dart:io';

import 'package:moj_majstor/models/Majstor.dart';

class EditProfileMajstor extends StatefulWidget {
  MajstorModel majstor;
  EditProfileMajstor({Key? key, required this.majstor}) : super(key: key);

  @override
  State<EditProfileMajstor> createState() => _EditProfileMajstorState();
}

class _EditProfileMajstorState extends State<EditProfileMajstor> {
  File? imageFile;
  set string(String value) => setState(() => widget.majstor.city = value);
  late String profilePhoto = widget.majstor.profilePicture ??
      'https://www.unmc.edu/cihc/_images/faculty/default.jpg';

  late TextEditingController namecontroller =
      TextEditingController(text: widget.majstor.fullName);
  late TextEditingController occupationcontroller =
      TextEditingController(text: widget.majstor.primaryOccupation);
  late TextEditingController aboutcontroller =
      TextEditingController(text: widget.majstor.bio);
  late TextEditingController phoneNumbercontroller =
      TextEditingController(text: widget.majstor.phoneNumber);
  late TextEditingController addresscontroller = TextEditingController(
      text: (widget.majstor.city ?? "") +
          ", " +
          (widget.majstor.streetAddress ?? ""));
  late TextEditingController tagcontroller = TextEditingController();

  get formkey => null;
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 100, 120, 254),
        title: const Text(
          'Izmeni Profil',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: (imageFile != null)
                        ? FileImage(File(imageFile!.path))
                        : NetworkImage(profilePhoto) as ImageProvider,
                    child: Stack(children: const [
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.photo_camera,
                              color: Color.fromARGB(255, 100, 120, 254),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
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
                            labelText: 'Ime i prezime',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.person),
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
                          controller: occupationcontroller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Zanimanje',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.engineering),
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Unesite zanimanje"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: phoneNumbercontroller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Broj telefona',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(
                                  errorText: "Unesite broj telefona"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: aboutcontroller,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Opis',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.description),
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Unesite opis"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextFormField(
                          controller: addresscontroller,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.map),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return InsertLocation(callback: (val) {
                                      setState(
                                          () => addresscontroller.text = val);
                                    });
                                  }),
                                );
                              },
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Adresa',
                            labelStyle: const TextStyle(color: Colors.black54),
                            prefixIcon: const Icon(Icons.home),
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Unesite adresu"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  children: widget.majstor.occupation!
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            deleteIcon: Icon(
                              Icons.close,
                              size: 20,
                            ),
                            onDeleted: () {
                              setState(() {
                                widget.majstor.occupation?.remove(e);
                              });
                            },
                            label: Text(
                              e,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextFormField(
                    controller: tagcontroller,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            widget.majstor.occupation?.add(tagcontroller.text);
                            tagcontroller.text = '';
                          });
                        },
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Tagovi',
                      hintText: 'Dodaj tag',
                      labelStyle: const TextStyle(color: Colors.black54),
                      prefixIcon: const Icon(Icons.tag),
                    ),
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "Unesite adresu"),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Sačuvaj izmene',
                        style: TextStyle(fontSize: 17),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 100, 120, 254),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
