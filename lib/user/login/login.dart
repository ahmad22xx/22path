import 'package:cleanx/Home.dart';
import 'package:cleanx/user/login/background.dart';
import 'package:cleanx/user/login/loginFun.dart';
import 'package:cleanx/user/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  LoginFun loginObj = new LoginFun();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 26,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromARGB(255, 0, 222, 233).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 9)
                  ]),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Email"),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromARGB(255, 0, 222, 233).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 9)
                  ]),
              child: TextField(
                controller: passWordController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Password"),
                obscureText: true,
              ),
            ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pushReplacement(
            //           context, MaterialPageRoute(builder: (context) => Home()));
            //     },
            //     child: Text(
            //       "Forgot your password?",
            //       style: TextStyle(fontSize: 12, color: Colors.grey),
            //     ),
            //   ),
            // ),
            SizedBox(height: 17),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 0, 222, 233),
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  EasyLoading.show(
                      dismissOnTap: true, maskType: EasyLoadingMaskType.custom);
                  await loginObj.login(
                      emailController.text, passWordController.text);
                  if (loginObj.message == 'success') {
                    // SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    // setState(() {
                    //   prefs.setString('email', emailController.text);
                    //   prefs.setString('password', passWordController.text);
                    // });
                    loginObj.getFirebaseToken();
                    EasyLoading.dismiss();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  } else {
                    EasyLoading.dismiss();
                    loginObj.message == null
                        ? EasyLoading.showError(
                            "Please cheek your internet connection",
                            maskType: EasyLoadingMaskType.custom,
                          )
                        : EasyLoading.showError("${loginObj.message}",
                            maskType: EasyLoadingMaskType.custom,
                            duration: Duration(seconds: 1));
                  }
                },
                child: Text(
                  "Sign In",
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              // alignment: Alignment.centerRight,
              // margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text(
                  "Don't Have an Account? Sign up",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
