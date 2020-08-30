import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/fcm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../StateManagement/messageState.dart';
import '../../StateManagement/notificationState.dart';
import 'package:provider/provider.dart';
import '../../StateManagement/bodyPage.dart';
import 'homeView.dart';
import '../People/people_in_contact_list.dart';
import '../Chat/chat.dart';

class HomeView extends StatefulWidget {
  final String uid;

  const HomeView({Key key, this.uid}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isDarkMode = false;

  String uid, photoUrl, displayName, email, phone;

  @override
  void initState() {
    super.initState();
    init();
    firebaseNotification();
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
    final NotificationState notificationState =
        Provider.of<NotificationState>(context, listen: false);

    final MessageState messageState =
        Provider.of<MessageState>(context, listen: false);

    final BodyPage bodyPage = Provider.of<BodyPage>(context);

    return SafeArea(
      child: Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: Scaffold(
          body: Container(
            child: Center(
              child: pageChooser(context),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 10,
            child: Container(
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.only(left: 80, right: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        bodyPage.setPageSelect("Home");
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          child: Icon(Icons.message_rounded)),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        bodyPage.setPageSelect("People");
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(Icons.group),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pageChooser(BuildContext context) {
    final BodyPage bodyPage = Provider.of<BodyPage>(context);
    switch (bodyPage.pageSelected) {
      case "Home":
        return HomePageView();
        break;
      case "People":
        return PeoplePageView();
        break;
      default:
        return HomePageView();
    }
  }
}
