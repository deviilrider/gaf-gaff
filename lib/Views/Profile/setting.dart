import 'package:flutter/material.dart';

class SettingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // ListTile(
          //   title: Text('Account'),
          //   leading: Icon(Icons.vpn_key),
          //   subtitle: Text('Privacy, security'),
          // ),
          ListTile(
            title: Text('Theme'),
            leading: Icon(Icons.color_lens),
            subtitle: Text('Dark mode, chat history'),
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
            subtitle: Text('Push Notifications, In app notifications'),
          ),
          ListTile(
            title: Text('Help'),
            leading: Icon(Icons.help),
            subtitle: Text('FAQs, Privacy Policy, Contact Us'),
          ),
          ListTile(
            title: Text('Share'),
            leading: Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}
