import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: Transform.scale(
          scale: 2,
          child: Lottie.asset(
            'assets/lottie/profilex.json',
            repeat: false,
          )),
    );
  }
}
