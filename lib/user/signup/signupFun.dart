import 'dart:convert';
import 'package:cleanx/const/URL.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class SignupFun {
  String messageID;
  String message;
  String token;

  Future registerUser(
    String fname,
    String lname,
    String email,
    String password,
    String streetxadress,
    String regionName,
    String regionCode,
  ) async {
    try {
      http.Response response = await http.get(Uri.parse(url +
          "type=add-user&f_name=$fname&l_name=$lname&email=$email&password=$password&street_num=$streetxadress&region_name=$regionName&region_code=$regionCode"));
      // print('xxxx${response.body}');
      var result = jsonDecode(response.body);
      messageID = result[0]['message'];
      // message = response.body;
      // if (result[0] != null) {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("token", result[0]['token']);
      // }
    } catch (e) {
      print(e);
    }
  }
}
