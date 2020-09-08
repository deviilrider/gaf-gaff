import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/models/message.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:gafgaff/widgets/circular_button.dart';

class MessageReadUnreadStatus extends StatelessWidget {
  final stream;

  MessageReadUnreadStatus({
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
            if (message.status == "unread") {
              return CircularButton(
                radius: 10,
                backGroundColor: UniversalVariables.maincolor3,
              );
            }
          }
          return SizedBox();
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
}
