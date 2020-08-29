import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gafgaff/Models/user.dart';
import 'package:gafgaff/Views/AuthScreens/updateInfo.dart';
import 'package:gafgaff/Views/AuthScreens/verifyPhone.dart';
import 'package:gafgaff/Views/BaseWidget/route_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GafGaffUser user;
  User currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  BuildContext get context => context;

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
          print("number" + phone);
          print("Verfication Id" + verId);
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
  // signOut() {
  //   _auth.signOut();
  // }

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

  Future<Null> handleSignIn(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser = (await _auth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'displayName': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'phone': firebaseUser.phoneNumber,
          "fcmToken": await _firebaseMessaging.getToken(),
        });

        FirebaseFirestore.instance
            .collection("display_names")
            .doc(firebaseUser.displayName)
            .set({'displayName': firebaseUser.displayName});

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('uid', currentUser.uid);
        await prefs.setString('displayName', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
        await prefs.setString('phone', currentUser.phoneNumber);
        await prefs.setString('email', currentUser.email);
        prefs.setBool('isLoggedIn', true);
        RoutePage()..routePage(context);
      } else {
        // Write data to local
        await prefs.setString('uid', documents[0].data()['uid']);
        await prefs.setString(
            'displayName', documents[0].data()['displayName']);
        await prefs.setString('photoUrl', documents[0].data()['photoUrl']);
        await prefs.setString('phone', documents[0].data()['phone']);
        await prefs.setString('email', documents[0].data()['email']);
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          "fcmToken": await _firebaseMessaging.getToken(),
        });
        prefs.setBool('isLoggedIn', true);
        RoutePage()..routePage(context);
      }
      RoutePage()..routePage(context);
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
    }
  }

  //signout
  Future<Null> handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    RoutePage()..routePage(context);
  }
}
