import 'dart:ui';
import 'package:flutter/material.dart';
import '../Views/AuthScreens/login.dart';
import '../Constants/colors.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // new Future.delayed(const Duration(seconds: 2), () => routePage(context));
    Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginView())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Image(
            image: AssetImage("assets/images/gaf-gaff.png"),
            height: 80,
            width: 80,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            height: 40,
            child: Column(
              children: [
                Text(
                  'powered by',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'E. Deal Nepal',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: maincolor3),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
