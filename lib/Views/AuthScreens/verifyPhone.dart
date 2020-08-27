import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';

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
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Image(
                image: AssetImage("assets/images/gaf-gaff.png"),
                height: 80,
                width: 80,
              ),
              formWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  formWidget(BuildContext context) {
    TextEditingController code1 = TextEditingController();
    TextEditingController code2 = TextEditingController();
    TextEditingController code3 = TextEditingController();
    TextEditingController code4 = TextEditingController();
    TextEditingController code5 = TextEditingController();
    TextEditingController code6 = TextEditingController();
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
                ? FlatButton(onPressed: () {}, child: Text('Resend'))
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                codeField(code1),
                codeField(code2),
                codeField(code3),
                codeField(code4),
                codeField(code5),
                codeField(code6),
              ],
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => UpdateInfoView()));
              },
              child: Text('Verify Phone Number'),
            )
          ],
        ));
  }

  codeField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 40,
      width: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: maincolor2, width: 1, style: BorderStyle.solid)),
      child: TextFormField(
        controller: controller,
        maxLength: 1,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
