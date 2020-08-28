import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Views/Profile/setting.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //appbar
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 30,
            ),
            //fetch user image
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 80,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // fetch user name
            Text(
              'Subash Pandey',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              '+977 9851255497',
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12),
            ),
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
    ));
  }
}
