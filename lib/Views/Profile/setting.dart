import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:share/share.dart';

class SettingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SwitchListTile(
            value: false,
            onChanged: (value) {},
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
            },
            title: Text('Message Requests'),
            leading: CircleAvatar(child: Icon(Icons.comment_rounded)),
          ),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
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
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Switch Phone Number'),
            leading: CircleAvatar(child: Icon(Icons.switch_account)),
          ),
          ListTile(
            onTap: () {
              ALertDialogs()..getErrorDialog(context, 'Features Coming Soon');
            },
            title: Text('Delete My Account'),
            leading: CircleAvatar(child: Icon(Icons.delete_forever_rounded)),
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
