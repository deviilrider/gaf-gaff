import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/resources/chat_methods.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/utils/call_utilities.dart';
import 'package:gafgaff/utils/permissions.dart';
import 'package:gafgaff/widgets/circular_button.dart';
import 'package:provider/provider.dart';

import 'widgets/add_button.dart';

class PublicProfileView extends StatelessWidget {
  final User receiver;

  PublicProfileView({this.receiver});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
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
                  child: receiver.profilePhoto != null
                      ? Container(
                          height: 98,
                          width: 98,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: NetworkImage(receiver.profilePhoto)),
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
                receiver.name != null ? receiver.name : "Full Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularButton(
                    onTap: userProvider.getUser.userRole == "pro"
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PublicProfileView(
                                          receiver: receiver,
                                        )));
                          }
                        : () {
                            ALertDialogs().getErrorDialog(context,
                                'This feature is available for pro user only. Contact Admin');
                          },
                    icon: Icons.call,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircularButton(
                    onTap: userProvider.getUser.userRole == "pro"
                        ? () async {
                            bool permission = await Permissions
                                .cameraAndMicrophonePermissionsGranted();

                            if (permission) {
                              CallUtils().dial(
                                  from: userProvider.getUser,
                                  to: receiver,
                                  context: context);
                              // callNotification();
                            } else {
                              ALertDialogs().getErrorDialog(
                                  context, 'No permission granted');
                            }
                          }
                        : () {
                            ALertDialogs().getErrorDialog(context,
                                'This feature is available for pro user only. Contact Admin');
                          },
                    icon: Icons.videocam,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  AddDeleteRequestButton(
                    contactUser: receiver,
                    currentUser: userProvider.getUser,
                    tile: true,
                  ),
                ],
              ),
              Divider(),
              AddDeleteRequestButton(
                contactUser: receiver,
                currentUser: userProvider.getUser,
              ),
              ListTile(
                onTap: () {
                  ALertDialogs()
                    ..getErrorDialog(context, 'Features Coming Soon');
                  // ChatMethods().searchMessage(context, receiver.uid);
                },
                title: Text('Search In Conversation'),
                leading: CircleAvatar(child: Icon(Icons.search)),
              ),
              ListTile(
                onTap: () {
                  ALertDialogs()
                    ..deleteConversation(
                        context, userProvider.getUser.uid, receiver.uid);
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
