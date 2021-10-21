import 'package:cleanx/Home.dart';
import 'package:cleanx/Start/slid2.dart';
import 'package:cleanx/Start/slide1.dart';
import 'package:cleanx/const/colors.dart';
import 'package:cleanx/user/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Start extends StatefulWidget {
  const Start({Key key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  PageController pageViewController = PageController();
  var indexColor = 0;
  var pagelist = [
    Slid2(),
    Slid1(),
    Login(),
  ];

  @override
  void initState() {
    initSherd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageViewController,
                        onPageChanged: (int page) {
                          setState(() {
                            indexColor = page;
                          });
                        },
                        itemCount: pagelist.length,
                        itemBuilder: (context, index) {
                          return pagelist[index];
                        }),
                  ),
                ],
              ),
              // ---- indector -----
              Positioned(
                bottom: 26,
                left: 20,
                child: Container(
                    height: 39,
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: List.generate(
                        pagelist.length,
                        (index) => Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: mainColor, width: 3.5),
                            color: indexColor == index
                                ? Colors.greenAccent
                                : Colors.white,
                          ),
                        ),
                      ),
                    )),
              ),
              // ----- Elevated Button -----
              Visibility(
                visible: indexColor == 2 ? false : true,
                child: Positioned(
                  bottom: 22,
                  right: 22,
                  child: TextButton(
                    child: Text(
                      "Next",
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 25,
                          color: mainColor),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var location = prefs.getString("address");
                      if (location == "" && indexColor == 1) {
                        EasyLoading.showError("Please Enter your Location",
                            maskType: EasyLoadingMaskType.custom,
                            dismissOnTap: true,
                            duration: Duration(seconds: 2));
                      } else {
                        if (indexColor == 0 ||
                            indexColor == 1 ||
                            indexColor == 2) {
                          pageViewController.nextPage(
                              duration: Duration(milliseconds: 30),
                              curve: Curves.easeOut);
                        } else {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void initSherd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", "");
  }
}
