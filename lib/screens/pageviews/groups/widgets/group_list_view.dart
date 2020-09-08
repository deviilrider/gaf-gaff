import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gafgaff/models/group.dart';
import 'package:gafgaff/resources/group_chat_methods.dart';
import 'package:gafgaff/screens/groupchatscreens/group_chat_screen.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:gafgaff/widgets/custom_tile.dart';

import 'last_message_container.dart';

class GroupContactView extends StatelessWidget {
  final String gid;
  final GroupChatMethods _groupChatMethods = GroupChatMethods();

  GroupContactView(this.gid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Group>(
      future: _groupChatMethods.getGroupDetails(gid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Group group = snapshot.data;

          return ViewLayout(
            group: group,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Group group;
  final GroupChatMethods _groupChatMethods = GroupChatMethods();

  ViewLayout({
    @required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      margin: EdgeInsets.only(bottom: 10),
      mini: false,
      onTap: () {
        // ChatMethods().setMessageRead(
        //   senderId: userProvider.getUser.uid,
        //   receiverId: contact.uid,
        // );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupChat(
                group: group,
              ),
            ));
      },
      title: Text(
        (group != null ? group.groupName : null) != null
            ? group.groupName
            : "..",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: LastMessageContainer(
        stream: _groupChatMethods.fetchLastMessageBetween(groupID: group.gid),
      ),
      // trailing: MessageReadUnreadStatus(
      //   stream: _chatMethods.fetchMessageSeenStatus(
      //     senderId: userProvider.getUser.uid,
      //     receiverId: contact.uid,
      //   ),
      // ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 81,
              backgroundColor: UniversalVariables.maincolor3,
              child: group.groupProfilePhoto != null
                  ? CachedImage(
                      group.groupProfilePhoto,
                      radius: 80,
                      isRound: true,
                    )
                  : Icon(Icons.group_rounded),
            ),
            // OnlineDotIndicator(
            //   uid: contact.uid,
            // ),
          ],
        ),
      ),
    );
  }
}
