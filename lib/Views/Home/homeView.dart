import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Models/fcm.dart';
import 'package:gafgaff/Models/user.dart';
import 'package:gafgaff/Views/Chat/chat.dart';
import 'package:gafgaff/Views/Chat/chatList.dart';
import 'package:gafgaff/Views/Home/chatList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/appbar.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  bool isDarkMode;

  String uid, photoUrl, displayName, email, phone;
  List<GafGaffUser> usersList = List<GafGaffUser>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid');
      displayName = prefs.getString('displayName');
      photoUrl = prefs.getString('photoUrl');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var badgeNot;
  int postNot = 0;
  int followerNot = 0;
  int articleNot = 0;

  firebaseNotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Notification-Type: $message");
        // if (msg == NotificationServices.POST.toString()) {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (context) => PostNotificationPage(pid: doc,)));
        // }

        // fetchNotificationTotal();
        // fetchUnreadMessageTotal();
      },
      onLaunch: (Map<String, dynamic> message) async {
        // fetchNotificationTotal();
        // fetchUnreadMessageTotal();

        print("onLaunch: $message");
        String msg = message['data']['type'];
        print("onMessage: $msg");

        if (msg == NotificationServices.MESSAGE.toString()) {
          String receiverId = message['data']['receiverId'];
          String receiverName = message['data']['receiverName'];
          String receiverImg = message['data']['receiverImg'];

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatExtendedView(
                    peerAvatar: receiverImg,
                    peerName: receiverName,
                    peerId: receiverId,
                  )));
        }
        // fetchNotificationTotal();
        // fetchUnreadMessageTotal();
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // fetchNotificationTotal();
        // fetchUnreadMessageTotal();

        print("onResume: $message");

        // * WAITING FOR NOTIFICATION TYPE
        String msg = message['data']['type'];
        print("onMessage: $msg");

        if (msg == NotificationServices.MESSAGE.toString()) {
          String receiverId = message['data']['receiverId'];
          String receiverName = message['data']['receiverName'];
          String receiverImg = message['data']['receiverImg'];

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatExtendedView(
                    peerAvatar: receiverImg,
                    peerName: receiverName,
                    peerId: receiverId,
                  )));
        }
        // fetchNotificationTotal();
        // fetchUnreadMessageTotal();
        // _navigateToItemDetail(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CostumAppBar(
              pagetitle: "Gaf-Gaff",
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.photo_camera,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.edit,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(child: Message())
          ],
        ),
      ),
    ));
  }
}
