import 'dart:convert';

import 'package:cleanx/const/URL.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginFun {
  int messageID;
  String message;
  Future login(String email, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url" + "type=login&email=$email&password=$password"),
      );
      print(response.body);
      var result = jsonDecode(response.body);
      messageID = result[0]['message_id'];
      message = result[0]['message'];
      if (result[0]['message'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("fname", result[0]['f_name']);
        prefs.setString("lname", result[0]['l_name']);
        prefs.setString("email", result[0]['email']);
        // prefs.setString("password", result[0]['passwordd']);
        prefs.setString("street_num", result[0]['street_num']);
        prefs.setString("region_name", result[0]['region_name']);
        prefs.setString("region_code", result[0]['region_code']);
        prefs.setString("token", result[0]['token']);
      }
    } catch (e) {
      print(e);
    }
  }

  void getFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token');
    FirebaseMessaging.instance.getToken().then((value) {
      String token = value;
      print(token);
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
}
