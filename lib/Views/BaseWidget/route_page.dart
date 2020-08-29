import 'package:flutter/material.dart';
import 'package:gafgaff/Views/AuthScreens/loginpage.dart';
import 'package:gafgaff/Views/Home/mainhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutePage {
  Future<void> routePage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String useruid = prefs.getString('uid');
    return isLoggedIn
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeView(
                      uid: useruid,
                    )))
        : Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPageView()));
  }
}
