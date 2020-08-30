import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/auth.dart';
import 'package:gafgaff/Views/Chat/message_request.dart';
import 'package:gafgaff/Views/Pages/add_request_view.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingListView extends StatefulWidget {
  @override
  _SettingListViewState createState() => _SettingListViewState();
}

class _SettingListViewState extends State<SettingListView> {
  bool isDarkMode;

  String uid, photoUrl, displayName, email, phone;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SwitchListTile(
            value: !isDarkMode ? false : true,
            onChanged: (value) async {
              var prefs = await SharedPreferences.getInstance();
              setState(() {
                prefs.setBool('isDarkMode', value);
                isDarkMode = value;
              });
            },
            title: Row(
              children: [
                CircleAvatar(child: Icon(Icons.nightlight_round)),
                SizedBox(
                  width: 14,
                ),
                Text('Dark Mode'),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Notifications'),
            leading: CircleAvatar(child: Icon(Icons.notifications)),
          ),
          Divider(),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MessageRequest()));
            },
            title: Text('Message Requests'),
            leading: CircleAvatar(child: Icon(Icons.comment_rounded)),
          ),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddRequests(
              //               uid: uid,
              //             )));
            },
            title: Text('Add Requests'),
            leading: CircleAvatar(child: Icon(Icons.person_add)),
          ),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Blocked Users'),
            leading: CircleAvatar(child: Icon(Icons.block)),
          ),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Story'),
            leading: CircleAvatar(child: Icon(Icons.flip_sharp)),
          ),
          // ListTile(
          //   onTap: () {
          //     ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
          //   },
          //   title: Text('Switch Phone Number'),
          //   leading: CircleAvatar(child: Icon(Icons.switch_account)),
          // ),
          ListTile(
            onTap: () {
              ALertDialogs()..delteAccount(context, uid);
              //         _firestore
              // .collection("users")
              // .doc(currentUserId)
              // .collection("following")
              // .doc(followingUserId)
              // .delete();
            },
            title: Text('Delete My Account'),
            leading: CircleAvatar(child: Icon(Icons.delete_forever_rounded)),
          ),
          ListTile(
            onTap: () {
              AuthServices()..handleSignOut(context);
            },
            title: Text('LogOut'),
            leading: CircleAvatar(child: Icon(Icons.exit_to_app)),
          ),
          Divider(),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'More Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Report Problem'),
            leading: CircleAvatar(child: Icon(Icons.report)),
          ),
          ListTile(
              onTap: () {
                ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
              },
              title: Text('Contact Us'),
              leading: CircleAvatar(child: Icon(Icons.contact_page))),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Help'),
            leading: CircleAvatar(child: Icon(Icons.help)),
            subtitle: Text('FAQs, Privacy Policy & Terms'),
          ),
          ListTile(
            title: Text('Share'),
            leading: CircleAvatar(child: Icon(Icons.share)),
            onTap: () {
              Share.share(
                  'Check Out Gaf-Gaff App for secure chat: https://play.google.com/store/apps/details?id=com.edeal.gafgaff ');
            },
          ),
        ],
      ),
    );
  }
}
