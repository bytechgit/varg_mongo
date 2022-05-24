import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Kategorija extends StatefulWidget {
  final String slika;
  final String zanimanje;
  const Kategorija({Key? key, required this.slika, required this.zanimanje})
      : super(key: key);

  @override
  State<Kategorija> createState() => _KategorijaState();
}

class _KategorijaState extends State<Kategorija> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Container(
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          //color: Colors.red,
          // shape: RoundedRectangleBorder(
          //  borderRadius: BorderRadius.circular(20.0),
          //),
          //  shadowColor: Colors.black,
          // elevation: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(255, 161, 43, 1),
                Color.fromRGBO(255, 96, 26, 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                        child: FittedBox(
                          child: Text(
                            widget.zanimanje,
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Century'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                  child: SimpleShadow(
                    opacity: 0.3, // Default: 0.5
                    color: Colors.black, // Default: Black
                    offset: Offset(8, 8), // Default: Offset(2, 2)
                    sigma: 2,
                    child: Image(
                      image: AssetImage(widget.slika),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
