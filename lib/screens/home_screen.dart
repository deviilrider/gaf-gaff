import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gafgaff/constants/colors.dart';
import 'package:gafgaff/models/fcm.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/screens/Profile/profileview.dart';
import 'package:gafgaff/screens/Profile/publicProfileView.dart';
import 'package:gafgaff/screens/chatscreens/chat_screen.dart';
import 'package:gafgaff/screens/pageviews/groups/group_list_view.dart';
import 'package:provider/provider.dart';
import 'package:gafgaff/enum/user_state.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/resources/local_db/repository/log_repository.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/screens/pageviews/chats/chat_list_screen.dart';
import 'package:gafgaff/screens/pageviews/logs/log_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;

  final AuthMethods _authMethods = AuthMethods();
  // final LogRepository _logRepository = LogRepository(isHive: true);
  // final LogRepository _logRepository = LogRepository(isHive: false);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
      AuthMethods().updateUserfcmToken(userProvider.getUser.uid);
      firebaseNotification();
      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
          String senderId = message['data']['senderId'];

          // getting user instance
          User user = await _authMethods.getUserDetailsById(senderId);
          //redirecting
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatScreen(
                    receiver: user,
                  )));
        }
        if (msg == NotificationServices.CALL.toString()) {
          String senderId = message['data']['senderId'];

          // getting user instance
          User user = await _authMethods.getUserDetailsById(senderId);
          //redirecting
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatScreen(
                    receiver: user,
                  )));
        }
        if (msg == NotificationServices.ADD.toString()) {
          String senderId = message['data']['senderId'];

          // getting user instance
          User user = await _authMethods.getUserDetailsById(senderId);
          //redirecting
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PublicProfileView(
                    receiver: user,
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
          String senderId = message['data']['senderId'];

          // getting user instance
          User user = await _authMethods.getUserDetailsById(senderId);
          //redirecting
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatScreen(
                    receiver: user,
                  )));
        }
        if (msg == NotificationServices.CALL.toString()) {
          String senderId = message['data']['senderId'];

          // getting user instance
          User user = await _authMethods.getUserDetailsById(senderId);
          //redirecting
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatScreen(
                    receiver: user,
                  )));
        }
        if (msg == NotificationServices.ADD.toString()) {
          String senderId = message['data']['senderId'];

          // getting user instance
          User user = await _authMethods.getUserDetailsById(senderId);
          //redirecting
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PublicProfileView(
                    receiver: user,
                  )));
        }

        // fetchNotificationTotal();
        // fetchUnreadMessageTotal();
        // _navigateToItemDetail(message);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: TabBar(indicatorColor: Colors.transparent, tabs: [
                Tab(
                    icon: Icon(
                  Icons.chat_bubble_outline,
                  color: maincolor3,
                )),
                Tab(
                    icon: Icon(
                  Icons.group,
                  color: maincolor3,
                )),
                Tab(
                    icon: Icon(
                  Icons.call_outlined,
                  color: maincolor3,
                )),
                Tab(
                    icon: Icon(
                  Icons.settings,
                  color: maincolor3,
                )),
              ])),
          body: TabBarView(
            children: [
              ChatListScreen(),
              GroupChatScreen(),
              LogScreen(),
              ProfileView()
            ],
          ),
        ),
      ),
    );
  }
}
