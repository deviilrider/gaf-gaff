import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Models/user.dart';
import 'package:gafgaff/Views/AuthScreens/updateInfo.dart';
import 'package:gafgaff/Views/AuthScreens/verifyPhone.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GafGaffUser user;

  Future createUserWithPhone(String phone, BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateInfoView(
                          phone: phone,
                          uid: result.user.uid,
                        )));
            Navigator.pop(context);
          }).catchError((e) => print(e));
        },
        verificationFailed: (FirebaseAuthException exception) {
          print('error: ${exception.message}');
        },
        codeSent: (String verId, [int forceToken]) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyPhoneView(
                        number: phone,
                        verId: verId,
                      )));
        },
        codeAutoRetrievalTimeout: (String verifyId) {
          var verId = verifyId;
          print(verId);
        });
  }

  Future<void> addDataToDb(String uid, String name, String photoUrl,
      String phone, BuildContext context) async {
    _firestore.collection("display_names").doc(name).set({'displayName': name});

    user = GafGaffUser(
      uid: uid,
      phone: phone,
      displayName: name,
      photoUrl: photoUrl,
      fcmToken: await _firebaseMessaging.getToken(),
    );
    print("User notification token added");

    return _firestore.collection("users").doc(uid).set(user.toMap());
  }

  Future<void> updateUserToken(User currentUser) async {
    user = GafGaffUser(
      fcmToken: await _firebaseMessaging.getToken(),
    );
    _firestore.collection("users").doc(currentUser.uid).update(
          user.toMap(),
        );
  }

  //sign out
  signOut() {
    _auth.signOut();
  }

  //authenticate user
  // authenticateUser(BuildContext context) {
  //   var authstate = _auth.currentUser;

  //   if (authstate != null) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => UpdateInfoView(
  //                   uid: authstate.uid,
  //                 )));
  //   } else {
  //     signInwithPhone();
  //   }
  // }

  //sigining with phone number
  signInwithPhone(
      String phoneNo, String verId, String code, BuildContext context) {
    var _credential = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: code.trim());
    _auth.signInWithCredential(_credential).then((UserCredential result) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateInfoView(
                    phone: phoneNo,
                    uid: result.user.uid,
                  )));
      Navigator.pop(context);
    }).catchError((e) => print(e));
  }
}
