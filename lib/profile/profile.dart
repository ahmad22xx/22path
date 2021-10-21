import 'package:cleanx/profile/free.dart';
import 'package:cleanx/user/login/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String fname;
  String lname;
  String email;
  String password;
  String streetxhouse;
  String regionName;
  String regionCode;
  bool isloading = true;
  DateTime dt;
  @override
  void initState() {
    _getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isloading
          ? Center(
              child: Container(),
            )
          : Column(
              children: [
                SizedBox(height: 40),
                ProfilePic(),
                SizedBox(height: 20),
                ProfileMenu(
                  text: "$fname $lname",
                  icon: "assets/svg/user.svg",
                  press: () {},
                ),
                // ProfileMenu(
                //   text: "Mobile",
                //   icon: "assets/svg/phone.svg",
                //   press: () {},
                // ),
                ProfileMenu(
                  text: "$email",
                  icon: "assets/svg/email.svg",
                  press: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => FreeX()));
                  },
                ),
                ProfileMenu(
                  text: "$streetxhouse",
                  icon: "assets/svg/street.svg",
                  press: () {},
                ),
                ProfileMenu(
                  text: "$regionCode",
                  icon: "assets/svg/code.svg",
                  press: () {},
                ),
                ProfileMenu(
                  text: "$regionName",
                  icon: "assets/svg/RegionC.svg",
                  press: () {},
                ),
                ProfileMenu(
                  text: "Log Out",
                  icon: "assets/svg/logout.svg",
                  press: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ],
            ),
    );
  }

  _getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fname = prefs.getString("fname");
    lname = prefs.getString("lname");
    email = prefs.getString("email");
    streetxhouse = prefs.getString("street_num");
    regionName = prefs.getString("region_name");
    regionCode = prefs.getString("region_code");
    isloading = false;
    setState(() {});
  }

  bool isnext() {
    DateTime dt = DateTime.parse('2021-11-26 08:00');
    DateTime dtnext = DateTime.parse('2021-11-26 11:00');
    if (DateTime(dt.year, dt.month, dt.day, dt.hour + 3) ==
        DateTime(dtnext.year, dtnext.month, dtnext.day, dtnext.hour)) {
      return true;
    } else {
      return false;
    }
  }
}
