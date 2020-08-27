import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Views/AuthScreens/login.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

import 'updateInfo.dart';

class VerifyPhoneView extends StatefulWidget {
  final String number;

  const VerifyPhoneView({Key key, this.number}) : super(key: key);
  @override
  _VerifyPhoneViewState createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  bool resend = false;
  final _formKey = GlobalKey<FormState>();

  String text = '';
  String error = "";

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 65), () {
      resend = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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

  formWidget(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Enter 6 digits validation code that is sent to +977-${widget.number} .',
                textAlign: TextAlign.center,
              ),
            ),
            resend
                ? FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginView()));
                    },
                    child: Text('Resend'))
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                otpNumberWidget(0),
                otpNumberWidget(1),
                otpNumberWidget(2),
                otpNumberWidget(3),
                otpNumberWidget(4),
                otpNumberWidget(5),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 10),
            ),
            RaisedButton(
              elevation: 10,
              color: maincolor3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                if (text != "") {
                  if (text.length == 6) {
                    print(text);
                    Dialogs()..getDialog(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateInfoView()));
                  } else if (text.length < 6) {
                    setState(() {
                      error = '* Please enter 6 digits code';
                    });
                  } else {
                    setState(() {
                      error = '* Please enter only 6 digits code';
                    });
                  }
                } else {
                  print('error');
                  setState(() {
                    error = '* Please enter code for verification';
                  });
                }
              },
              child:
                  Text('Verify Phone Number', style: TextStyle(fontSize: 15)),
            ),
            NumericKeyboard(
              onKeyboardTap: _onKeyboardTap,
              textColor: maincolor1,
              rightIcon: Icon(
                Icons.backspace,
                color: maincolor2,
              ),
              rightButtonFn: () {
                setState(() {
                  text = text.substring(0, text.length - 1);
                });
              },
            )
          ],
        ));
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          textScaleFactor: 1.2,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }
}
