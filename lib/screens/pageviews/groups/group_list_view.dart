import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/resources/group_chat_methods.dart';
import 'package:gafgaff/widgets/circular_button.dart';
import 'package:provider/provider.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/screens/pageviews/groups/widgets/quiet_box.dart';

import 'widgets/group_list_view.dart';

class GroupChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                //TODO
                // add a link to go to add group page
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    CircularButton(
                      icon: Icons.group_add,
                      radius: 50,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Create a group',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: GroupListContainer()),
          ],
        ),
      ),
    );
  }
}

class GroupListContainer extends StatelessWidget {
  final GroupChatMethods _groupChatMethods = GroupChatMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _groupChatMethods.fetchGroupsMine(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox(
                  heading: "This is where all the groups are listed",
                  subtitle:
                      "Search for your friends and family in group or make group chat room with them",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  return GroupContactView(docList[index].data['gid']);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
