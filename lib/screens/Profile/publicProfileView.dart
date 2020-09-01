import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicProfileView extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  const PublicProfileView(
      {Key key, this.peerId, this.peerAvatar, this.peerName})
      : super(key: key);

  @override
  _PublicProfileViewState createState() => _PublicProfileViewState();
}

class _PublicProfileViewState extends State<PublicProfileView> {
  String uid;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: SafeArea(
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
                height: 20,
              ),
              //fetch user image
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: CircleAvatar(
                  radius: 50,
                  child: widget.peerAvatar != null
                      ? Container(
                          height: 98,
                          width: 98,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: NetworkImage(widget.peerAvatar)),
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
                widget.peerName != null ? widget.peerName : "Full Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          Icons.call,
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
                          Icons.videocam,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              ListTile(
                onTap: () {
                  ALertDialogs()
                    ..deleteConversation(context, uid, widget.peerId);
                },
                title: Text('Delete All Conversation'),
                leading: CircleAvatar(child: Icon(Icons.delete_forever)),
              ),
              // AddPeopleTile(
              //   currentUserId: uid,
              //   followingUserId: widget.peerId,
              // ),
              ListTile(
                onTap: () {
                  ALertDialogs()
                    ..getErrorDialog(context, 'Features Coming Soon');
                },
                title: Text('Blocked Users'),
                leading: CircleAvatar(child: Icon(Icons.block)),
              ),
              ListTile(
                onTap: () {
                  ALertDialogs()
                    ..getErrorDialog(context, 'Features Coming Soon');
                },
                title: Text('Report Users'),
                leading: CircleAvatar(child: Icon(Icons.report)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: ListTile(
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
        ),
      ),
    ));
  }
}
