import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/auth.dart';
import 'package:gafgaff/Views/AuthScreens/updateInfo.dart';
import '../../Constants/colors.dart';
import '../../Widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'verifyPhone.dart';

class LoginView extends StatelessWidget {
  TextEditingController phoneNumberController = TextEditingController();
  String verificationId;

  final _formKey = GlobalKey<FormState>();
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
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Enter your valid phone number to join gaf-gaff community. We will send you one time password on this phone number.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: CostumTextField(
                hint: '981-2345678',
                label: 'Phone Number',
                obscureValue: false,
                keyboardType: TextInputType.number,
                prefix: Text('+977 '),
                prefixIcon: Icon(Icons.phone),
                controller: phoneNumberController,
                validator: (phoneNumber) {
                  if (phoneNumber.isEmpty || phoneNumber.toString().length > 10)
                    return '* Please enter valid Phone Number';
                  else
                    return null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                var phone = "+977 " + phoneNumberController.text;
                AuthServices().createUserWithPhone(phone, context);
                // verifyPhone(phoneNumberController.text, context);

                // if (_formKey.currentState.validate()) {
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => VerifyPhoneView(
                //             // number: phoneNumberController.text,
                //             )));
                // }
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: maincolor3,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  // Future<void> verifyPhone(String phoneNo, BuildContext context) async {
  //   var phoneNumber = '+977 ' + phoneNo;
  //   final PhoneVerificationCompleted verificationCompleted =
  //       (AuthCredential authResult) {
  //     print(phoneNumber);
  //     FirebaseAuth.instance.signInWithCredential(authResult).then((value) {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => UpdateInfoView(uid: value.user.uid)));
  //     });
  //   };

  //   final PhoneVerificationFailed verificationFailed =
  //       (FirebaseAuthException authException) {
  //     print('${authException.message}');
  //   };

  //   final PhoneCodeSent codeSent = (String verId, [int forceResend]) {
  //     this.verificationId = verId;
  //     print(phoneNumber);
  //     if (verId != null) {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => VerifyPhoneView(
  //                     number: phoneNumber,
  //                     verId: this.verificationId,
  //                   )));
  //     }
  //   };

  //   final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
  //     this.verificationId = verId;
  //   };

  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: verificationCompleted,
  //       verificationFailed: verificationFailed,
  //       timeout: Duration(seconds: 60),
  //       codeSent: codeSent,
  //       codeAutoRetrievalTimeout: autoRetrievalTimeout);
  // }
}
