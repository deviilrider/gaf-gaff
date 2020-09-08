import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/models/call.dart';
import 'package:gafgaff/models/fcm.dart';
import 'package:gafgaff/models/log.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/resources/call_methods.dart';
import 'package:gafgaff/resources/local_db/repository/log_repository.dart';
import 'package:gafgaff/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  Future fetchUserFcmToken(String ownerUid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("users").document(ownerUid).get();
    return snapshot.data["fcmToken"];
  }

  dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    // * FETCHING USER FCM-TOKEN
    fetchUserFcmToken(to.uid).then((value) {
      print("$value");
      // * SENDING NOTIFICATION
      // setState(() {
      //   if (type == 0) {
      //     messageContent = content;
      //   } else if (type == 1) {
      //     messageContent = '$displayName send you a photo.';
      //   } else {
      //     messageContent = '$displayName send you a sticker.';
      //   }
      // });

      FcmNotification()
        ..fcmCallNotify(value, receiverId: to.uid, context: context)
            .then((value) {
          print("Call Notification Successfully Sent");
        });
    });
    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // enter log
      LogRepository.addLogs(log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
