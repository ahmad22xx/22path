import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Slid2 extends StatefulWidget {
  Slid2();

  @override
  _Slid2 createState() => _Slid2();
}

class _Slid2 extends State<Slid2> {
  int colorx;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    stringTOcolor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300,
                    width: 300,
                    child: Lottie.asset('assets/lottie/clean.json')),
                Container(
                  height: 300,
                  width: 350,
                  child: Text(
                      "No time to clean the house? Rest easy and let a Tasker help. Make your home look spotless with efficient one time cleaning",
                      style: TextStyle(fontFamily: "Raleway", fontSize: 25)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void stringTOcolor() {
    Color color = new Color(0xFFD20100);
    String colorString = color.toString(); // Color(0x12345678)
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    colorx = int.parse(valueString, radix: 16);
  }
}
