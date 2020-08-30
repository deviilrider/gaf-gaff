import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/auth.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/fcm.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/ViewModel/home_viewmodel.dart';
import 'package:gafgaff/Views/Chat/chat.dart';
import 'package:gafgaff/Views/Chat/chatList.dart';
import 'package:gafgaff/Views/Widget/user_search.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/appbar.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  bool isDarkMode;

  var _repository = Repository();
  String uid, photoUrl, displayName, email, phone;
  List<GafGaffUser> usersList = List<GafGaffUser>();

  @override
  void initState() {
    super.initState();
    init();
    searchUserList();
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

      _repository.updateUserfcmToken(uid);
    });
  }

  Future<void> searchUserList() async {
    User user = await _repository.getCurrentUser();

    var list = await _repository.fetchAllUsers(user);
    setState(() {
      usersList = list;
    });
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
                  onTap: () {
                    AuthServices()..searchUser(context);
                  },
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
            // * search ui button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          AuthServices()..searchUser(context);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: Colors.grey.shade700,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Search.....',
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            Message()
          ],
        ),
      ),
    ));
  }
}
