import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/auth.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Views/BaseWidget/route_page.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPageView extends StatefulWidget {
  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  String greet = "Hello";
  var _repository = Repository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  greeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      setState(() {
        greet = 'Good Morning,';
      });
    }
    if (hour >= 12) {
      setState(() {
        greet = 'Good Afternoon,';
      });
    }
    if (hour >= 17) {
      setState(() {
        greet = 'Good Evening,';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    greeting();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Image(
                image: AssetImage("assets/images/gaf-gaff.png"),
                height: 80,
                width: 80,
              ),
              formWidget(context),
            ],
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

  Widget formWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            '$greet \nWelcome to Gaf-Gaff Community, Please choose login method to enter the community.',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        RaisedButton(
          elevation: 10,
          color: maincolor2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            ALertDialogs()..getErrorDialog(context, 'Page Under Construction');
          },
          child: Text('Login with Phone',
              style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
        Text('OR'),
        RaisedButton(
          elevation: 10,
          color: maincolor3,
          child: Text('Login with Google', style: TextStyle(fontSize: 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () async {
            var result = await Connectivity().checkConnectivity();
            if (result == ConnectivityResult.none) {
              _noConnectionDialog();
            } else {
              Dialogs()..getDialog(context);
              AuthServices()..handleSignIn(context);
            }
          },
        ),
      ],
    );
  }

  _noConnectionDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection!'),
          content: const Text(
              'Please, check your internet connectivity and try again.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Try Again!'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
