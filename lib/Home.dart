import 'package:cleanx/Calender/samples/calendar/MView.dart';
import 'package:cleanx/profile/profile.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'const/colors.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  int currentSreen = 0;
  final widgetOptions = [
    CalendarAppointmentEditor(),
    Body(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions[selectedIndex],
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: mainColor,
          selectedItemBackgroundColor: mainColor,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            // BottomBar.currentSreen = index;
            selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          // FFNavigationBarItem(
          //   iconData: Icons.event,
          //   label: 'Appointment',
          // ),
          FFNavigationBarItem(
            iconData: Icons.people,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
