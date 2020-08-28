import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/constants.dart';

class ChatMessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      height: MediaQuery.of(context).size.height - 50,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return chatMessageItem(context
              // snapshot.data.documents[index]
              );
        },
        itemCount: 100,
      ),
    );
  }

  Widget chatMessageItem(
      // DocumentSnapshot snapshot
      BuildContext context) {
    bool senderuid = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: senderuid
                //  snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              senderuid
                  // snapshot['senderUid'] == _senderuid
                  ? senderLayout(context
                      // snapshot
                      )
                  : receiverLayout(context
                      // snapshot
                      )
            ],
          ),
        )
      ],
    );
  }

  Widget senderLayout(
      // DocumentSnapshot snapshot
      BuildContext context) {
    var type = "text";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // * SENDER TEXT || IMAGE
        // snapshot["timestamp"] != null
        //     ? timeShow(snapshot["timestamp"])
        //     :
        Text("--:--"),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child:
              // snapshot['type'] == 'text'
              type == 'text'
                  ? Container(
                      constraints: new BoxConstraints(
                          minWidth: 80,
                          maxWidth: MediaQuery.of(context).size.width * 0.5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.grey)),
                      child: Text("snapshot['message']",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                    )
                  : Container(
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(sampleImageUrl),
                        placeholder: AssetImage('assets/images/blankimage.png'),
                        width: 200.0,
                        height: 200.0,
                      ),
                    ),
        ),

        // *SENDER PROFILE IMAGE
        InkWell(
          onTap: () {},
          child: new Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: sampleImageUrl != null
                      ? NetworkImage(sampleImageUrl)
                      : AssetImage('assets/images/no_image.png'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 2.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget receiverLayout(
      // DocumentSnapshot snapshot
      BuildContext context) {
    var type = "text";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // * RECEIVER PROFILE IMAGE
        InkWell(
          onTap: () {},
          child: new Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: sampleImageUrl != null
                      ? NetworkImage(sampleImageUrl)
                      : AssetImage('assets/images/no_image.png'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 2.5,
              ),
            ),
          ),
        ),

        // * RECEIVER TEXT || IMAGE MESSAGE
        Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: type == 'text'
              //  snapshot['type'] == 'text'
              ? Container(
                  constraints: new BoxConstraints(
                      minWidth: 80,
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey)),
                  child: Text("snapshot['message']",
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                )
              : Container(
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(sampleImageUrl
                        // snapshot['photoUrl']
                        ),
                    placeholder: AssetImage('images/blankimage.png'),
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
        ),

        // snapshot["timestamp"] != null
        //     ? timeShow(snapshot["timestamp"])
        //     :
        Text("--:--")
      ],
    );
  }
}
