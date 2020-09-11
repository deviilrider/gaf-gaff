import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/models/message.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);
            final UserProvider userProvider =
                Provider.of<UserProvider>(context, listen: false);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      message.senderId == userProvider.getUser.uid
                          ? "You: ${message.message}"
                          : message.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      getDateTime(message.timestamp.toDate()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }

  String getDateTime(DateTime timestamp) {
    var databaseTime = timestamp;
    var time = databaseTime.toString();
    String dateFormate = DateFormat("dd MMM").format(DateTime.parse(time));

    return dateFormate;
  }
}
