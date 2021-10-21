import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Slid1 extends StatefulWidget {
  const Slid1({Key key}) : super(key: key);
  static bool istrue = false;

  @override
  _Slid1State createState() => _Slid1State();
}

class _Slid1State extends State<Slid1> {
  TextEditingController regionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 300,
                  width: 300,
                  child: Lottie.asset('assets/lottie/location.json')),
              Container(
                width: MediaQuery.of(context).size.width * 3 / 4,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color:
                              Color.fromARGB(255, 0, 222, 233).withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 9)
                    ]),
                child: TextField(
                  onChanged: (value) async {
                    if (value.length > 2) {
                      if (value.startsWith("510") ||
                          value.startsWith("511") ||
                          value.startsWith("513") ||
                          value.startsWith("514") ||
                          value.startsWith("515")) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("address", regionController.text);
                      } else {
                        FocusScope.of(context).unfocus();
                        setState(() async {
                          EasyLoading.showError(
                              "our services are not available in your Location",
                              maskType: EasyLoadingMaskType.custom,
                              dismissOnTap: true,
                              duration: Duration(seconds: 2));
                          regionController.text = '';
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("address", "");
                        });
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: regionController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Your address"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
