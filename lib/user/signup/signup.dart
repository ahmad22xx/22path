import 'package:cleanx/user/signup/background.dart';
import 'package:cleanx/user/signup/signupFun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SignupFun signupObj = new SignupFun();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController streetxhouseController = TextEditingController();
  TextEditingController regionCodeController = TextEditingController();
  TextEditingController regionNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController rePassWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Signup",
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
                  controller: firstNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "First Name"),
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
                  controller: lastNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Last Name"),
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
                  controller: streetxhouseController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "street name & House Number"),
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
                  controller: regionCodeController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Region Code"),
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
                  controller: regionNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Region name"),
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
                  controller: rePassWordController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Confirm Password"),
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    if (validateFUN()) {
                      FocusScope.of(context).unfocus();
                      EasyLoading.show(
                          maskType: EasyLoadingMaskType.custom,
                          dismissOnTap: true);
                      await signupObj.registerUser(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passWordController.text,
                        streetxhouseController.text,
                        regionNameController.text,
                        regionCodeController.text,
                      );
                      EasyLoading.dismiss();
                      if (signupObj.messageID == "success") {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess("Account has been Registred",
                            maskType: EasyLoadingMaskType.custom,
                            duration: Duration(seconds: 2));
                        Navigator.pop(context);
                      } else if (signupObj.messageID == "email exist") {
                        EasyLoading.showError("Email already Exist",
                            maskType: EasyLoadingMaskType.custom,
                            duration: Duration(seconds: 1));
                      } else {
                        EasyLoading.showError(
                            "Please cheek your internet Connection",
                            maskType: EasyLoadingMaskType.custom,
                            duration: Duration(seconds: 1));
                      }
                    }
                  },
                  child: Text(
                    "Signup",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFUN() {
    if (passWordController.text != rePassWordController.text ||
        passWordController.text.length < 5) {
      EasyLoading.showError("Please Enter correct passowrd",
          maskType: EasyLoadingMaskType.custom, duration: Duration(seconds: 2));
      return false;
    }
    if (firstNameController.text.length < 4 ||
        firstNameController.text.length > 16 ||
        lastNameController.text.length < 4 ||
        lastNameController.text.length > 16) {
      EasyLoading.showError("Please Enter Correct Name between 2 & 32",
          maskType: EasyLoadingMaskType.custom, duration: Duration(seconds: 2));
      return false;
    }
    if (streetxhouseController.text.length < 3) {
      EasyLoading.showError("Please Enter correct Street&House Number",
          maskType: EasyLoadingMaskType.custom, duration: Duration(seconds: 2));
      return false;
    }
    if (regionCodeController.text.length < 2) {
      EasyLoading.showError("Please Enter correct Region Code",
          maskType: EasyLoadingMaskType.custom, duration: Duration(seconds: 2));
      return false;
    }
    if (regionNameController.text.length < 2) {
      EasyLoading.showError("Please Enter correct Region Name",
          maskType: EasyLoadingMaskType.custom, duration: Duration(seconds: 2));
      return false;
    }

    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    String emailx = emailController.text.replaceAll(' ', '');
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(emailx) || emailController.text == null) {
      EasyLoading.showError("Enter a valid email address",
          maskType: EasyLoadingMaskType.custom, duration: Duration(seconds: 2));
      return false;
    }

    return true;
  }
}
