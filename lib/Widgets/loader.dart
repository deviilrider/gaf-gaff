import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loader() {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Platform.isIOS
            ? CupertinoActivityIndicator(
                radius: 35,
              )
            : CircularProgressIndicator(
                strokeWidth: 2,
              ),
        Image.asset(
          'assets/images/gaf-gaff.png',
          height: 30,
          width: 30,
        )
      ],
    ),
  );
}
