import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/models/group.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../publicProfileView.dart';

class GroupMemberViewPage extends StatelessWidget {
  final Group group;

  const GroupMemberViewPage({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Members'),
          backgroundColor: UniversalVariables.maincolor3,
          actions: [
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                label: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        body: memberList());
  }

  Widget memberList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("groups")
          .document(group.gid)
          .collection("members")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            // mention the arrow syntax if you get the time
            return getMembersInfo(context, snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  getMembersInfo(BuildContext context, DocumentSnapshot snapshot) {
    var time = snapshot.data['joinedOn'];
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return StreamBuilder(
      stream: Firestore.instance
          .collection("users")
          .where("uid", isEqualTo: snapshot.data['memberID'])
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot userData = snapshot.data.documents[index];
            User user = User.fromMap(userData.data);
            // mention the arrow syntax if you get the time
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PublicProfileView(
                                receiver: user,
                              )));
                },
                child: Container(
                    child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          child: CachedImage(
                            user.profilePhoto,
                            isRound: true,
                            radius: 40,
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Joined on: ${getJoinedDate(time.toDate())}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: user.uid == userProvider.getUser.uid
                            ? Icon(Icons.more_vert)
                            : Text('Admin'),
                      ),
                    )
                  ],
                )));
          },
        );
      },
    );
  }

  String getJoinedDate(DateTime timestamp) {
    var databaseTime = timestamp;
    var time = databaseTime.toString();
    String dateFormate =
        DateFormat("dd MMMM, yyyy").format(DateTime.parse(time));

    return dateFormate;
  }
}
