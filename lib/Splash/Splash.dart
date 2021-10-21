import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cleanx/Start/Start.dart';
import 'package:cleanx/controller.dart/stateController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Home.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final state = Get.put(StateController());
  String token;
  @override
  void initState() {
    run();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/splash3.png",
                  ),
                  fit: BoxFit.contain),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage("assets/images/splash1.png"),
                          fit: BoxFit.fill)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void run() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('counter', 0);
    token = prefs.getString("token");
    if (await cheek() == true) {
      await _getState();
      if (state.statue.value == 1) {
        stateDialog();
      } else {
        navigatpage();
      }
    }
  }

  void navigatpage() {
    if (token != null) {
      getFirebaseToken();
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home())));
    } else if (token == null || token == '') {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Start())));
    }
  }

  Future<bool> cheek() async {
    try {
      final result = await InternetAddress.lookup('google.pl');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');

      Get.defaultDialog(
        title: "Alert!",
        content: Text(
            "No Internet Connection please cheek your internet connection"),
        onConfirm: () => reset(),
        barrierDismissible: false,
        onCancel: () {
          if (Platform.isIOS) {
            try {
              exit(0);
            } catch (e) {
              SystemNavigator
                  .pop(); // for IOS, not true this, you can make comment this :)
            }
          } else {
            try {
              SystemNavigator.pop(); // sometimes it cant exit app
            } catch (e) {
              exit(0); // so i am giving crash to app ... sad :(
            }
          }
        },
      );
      return false;
    }
    return false;
  }

  void reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => Splash(),
      ),
    );
  }

  void stateDialog() {
    Get.defaultDialog(
      title: "Alert!",
      content: Text(state.message.value.toString()),
      onConfirm: () {
        Get.back();
        navigatpage();
      },
      barrierDismissible: false,
    );
  }

  void getFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token');
    FirebaseMessaging.instance.getToken().then((value) {
      String token = value;
      print("firebase toke: $token");
      sendToken(token, userToken);
    });
  }

  Future sendToken(String firebaseT, String userT) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            "http://www.bergischreinigung.de/ap.php?type=add-firebase-token&firebse_token=$firebaseT&user_token=$userT"),
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  _getState() async {
    try {
      http.Response response = await http.post(
        Uri.parse("http://www.bergischreinigung.de/ap.php?type=get-settings"),
      );
      print(response.body);
      var result = jsonDecode(response.body);
      var item = result[0]['message'][0];
      print(item);
      state.statue.value = item['app_status'];
      state.appointmentState.value = item['status_bool'];
      state.durationx.value = int.parse(item['duration']);
      state.startWork.value = int.parse(item['start_work']);
      state.endWork.value = int.parse(item['end_work']);
      state.message.value = item['status_message'];

      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
