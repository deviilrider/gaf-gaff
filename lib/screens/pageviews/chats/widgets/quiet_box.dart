import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          // color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                  color: UniversalVariables.lightBlueColor,
                  child: Text(
                    "START SEARCHING",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    AuthMethods()..searchUser(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
