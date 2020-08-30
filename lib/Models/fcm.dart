import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'user.dart';

import 'message.dart';

enum NotificationServices { POST, ARTICLE, MESSAGE }

class FcmNotification {
  static const String serverKEY =
      // "AAAAyAeaKWM:APA91bGVcJsGdPYDoBSmEJH4shXFW3j-rMRt03RlPtVO_ZyBSNbtiyJIfNfr5ZcX00rAUuMV-d-pIGthbUtrSVRSdzVpqa1n24iyT0zP1CvA11VNqfoGrUuDWwZnKCxlDnDCaGX1U0GG";
      "AAAAeAkVGw0:APA91bFhW2kgFwhwYomOI-P5sLJ32AfFEPmptja8lmQ4rJOEh5nzYQ0G44bydnjxyvI-Qa1gqhzfWqksMsZ5x5gn8z5g57mXzr-uzStj3j0OEGqEh3WqmsOyVH_64fs0RJsSxS3HLtU8";
  Future<void> fcmSendToCurrentUser(
      String fcmToken, String title, String content,
      {String type, String docID}) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "$content",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': '$type',
        'docid': '$docID',
        'senderId': '1234',
        'receiverId': '5678',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }

  Future<void> fcmSendToOtherUsers(
      String fcmToken, String title, String content,
      {String type, String docID}) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "$content",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': '$type',
        'docid': '$docID',
        'senderId': '1234',
        'receiverId': '5678',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }

  Future<void> fcmSendComments(
      String fcmToken, GafGaffUser currentUser, String title) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "${currentUser.displayName} comment on your post",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': 'notification message',
        'senderId': '1234',
        'receiverId': '5678',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }

  Future<void> fcmSendLikes(
      String fcmToken, GafGaffUser currentUser, String title) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "${currentUser.displayName} liked your post",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': 'notification message',
        'senderId': '1234',
        'receiverId': '5678',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }

  Future<void> fcmSendRepost(
      String fcmToken, User currentUser, String title) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "${currentUser.displayName} shared your post",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': 'notification message',
        'senderId': '1234',
        'receiverId': '5678',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }

  Future<void> fcmSendFollowinng(
      String fcmToken, GafGaffUser currentUser, String title) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "${currentUser.displayName} added you.",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': 'notification message',
        'senderId': '1234',
        'receiverId': '5678',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }

  Future<void> fcmSendMessage(String fcmToken, String title, String message,
      {String receiverId, String receiverName, String receiverImg}) async {
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': "$message",
        'title': "$title",
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'type': NotificationServices.MESSAGE.toString(),
        'senderId': '1234',
        'receiverId': '$receiverId',
        'receiverName': '$receiverName',
        'receiverImg': '$receiverImg',
        'title': 'title',
        'body': "Say hello",
        'tweetId': ""
      },
      'to': "$fcmToken",
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKEY'
        },
        body: body);
  }
}
