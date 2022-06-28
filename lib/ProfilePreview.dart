import 'package:flutter/material.dart';
import 'package:moj_majstor/models/Majstor.dart';
import 'package:moj_majstor/pom.dart';

class ProfilePreview extends StatefulWidget {
  final MajstorModel majstor;
  const ProfilePreview({Key? key, required this.majstor}) : super(key: key);

  @override
  State<ProfilePreview> createState() => _ProfilePreviewState();
}

class _ProfilePreviewState extends State<ProfilePreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350.0,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 10),
            child: Hero(
              tag: 'proba',
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 203, 202, 202),
                radius: 55,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.majstor.profilePicture ??
                      "https://www.jestiveslike.com/wp-content/uploads/2016/06/builder_bob_-_majstor_bob_03.jpg"),
                ),
              ),
            ),
          ),
          Text(
            widget.majstor.fullName,
            style: TextStyle(
                color: Color.fromARGB(255, 144, 159, 254),
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
          Text(
            'Elektricar',
            style: TextStyle(
                color: Color.fromRGBO(128, 128, 128, 1),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Poslovi',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(128, 128, 128, 1),
                        ),
                      ),
                      Text(
                        '10',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Pracenja',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(128, 128, 128, 1),
                        ),
                      ),
                      Text(
                        '10',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Ocena',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(128, 128, 128, 1),
                        ),
                      ),
                      Text(
                        '10',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Profil(
                      majstor: widget.majstor,
                    );
                  },
                ),
              ),
            },
            child: SizedBox(
              child: Center(
                child: Text(
                  'Vidi profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              height: 30,
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 144, 159, 254)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
