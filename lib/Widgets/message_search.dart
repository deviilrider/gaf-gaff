import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/models/message.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:intl/intl.dart';

import 'custom_tile.dart';

class MessageSearch extends SearchDelegate<String> {
  List<Message> messageList;
  MessageSearch({
    this.messageList,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Message> suggestionsList = query.isEmpty
        ? messageList
        : messageList.where((p) => p.message.contains(query)).toList();
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: suggestionsList.length != null ? suggestionsList.length : 0,
        itemBuilder: ((context, index) {
          return CustomTile(
            mini: false,
            onTap: () {
              // TODO go to message page
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ChatScreen(
              //               receiver: suggestionsList[index],
              //             )));
            },
            leading: getUserImage(senderUID: suggestionsList[index].senderId),
            title: Text(
              suggestionsList[index].message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              getMessageDate(suggestionsList[index].timestamp.toDate()),
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
          );
        }));
  }

  String getMessageDate(DateTime timestamp) {
    var databaseTime = timestamp;
    var time = databaseTime.toString();
    String dateFormate =
        DateFormat("dd MMMM, yyyy").format(DateTime.parse(time));

    return dateFormate;
  }

  getUserImage({String senderUID}) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('users')
              .where('uid', isEqualTo: senderUID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return Icon(Icons.person);
              }
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  User user = User.fromMap(docList[index].data);

                  return CachedImage(
                    user.profilePhoto,
                    radius: 25,
                    isRound: true,
                  );
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
