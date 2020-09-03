import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/constants/colors.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/screens/Profile/setting.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return SafeArea(
        child: PickupLayout(
            scaffold: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            //fetch user image
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: CircleAvatar(
                radius: 50,
                child: userProvider.getUser.profilePhoto != null
                    ? Container(
                        height: 98,
                        width: 98,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(
                                  userProvider.getUser.profilePhoto)),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 80,
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // fetch user name
            Text(
              userProvider.getUser.name != null
                  ? userProvider.getUser.name
                  : "Full Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              userProvider.getUser.status != null
                  ? userProvider.getUser.status
                  : '',
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12),
            ),
            Text(
              userProvider.getUser.email != null
                  ? userProvider.getUser.email
                  : '',
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12),
            ),
            Divider(),
            SettingListView(),
            Divider(),
            ListTile(
              title: Container(
                height: 40,
                child: Column(
                  children: [
                    Text(
                      'powered by',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'E. Deal Nepal',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: maincolor3),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
