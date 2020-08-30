import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/StateManagement/messageRequestState.dart';
// import 'package:gafgaff/StateManagement/messageRequestState.dart';
import 'package:gafgaff/StateManagement/messageState.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/constants.dart';
import '../../connections/repo.dart';
import '../../models/user.dart';
import 'chat.dart';
// import 'chatdetail.dart';
// import 'message_request.dart';

class Message extends StatefulWidget {
  Message({Key key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var _repository = Repository();
  FirebaseFirestore _firestore;
  GafGaffUser _user = GafGaffUser();
  List<GafGaffUser> usersList = List<GafGaffUser>();
  Future<List<DocumentSnapshot>> _future;
  bool seen = false;

  // * Ref step [TRY]
  List<GafGaffUser> messageUsersList = [];
  int _listUsers;

  @override
  void initState() {
    super.initState();
    // retrieveUserDetail();
    _repository.getCurrentUser().then((user) {
      // * FETCHING ALL USER (DB)
      _repository.fetchAllUsers(user).then((updatedList) {
        setState(() {
          // * fetch all users
          usersList = updatedList;
        });
      });

      // * FETCH USER
      _repository.fetchMessagedUser(user).then((value) {
        setState(() {
          messageUsersList.clear();
          messageUsersList = value;
        });
      });

      // * MESSAGE REQUEST
      // _repository.fetchMessageRequest(user.uid, context);
    });
    fetchUser();
  }

  GafGaffUser currentUser, user, messageUser;
  String lastMessage;
  String uid;
  List<String> messageUserUIDs = List<String>();

  void fetchUser() async {
    User currentUser = await _repository.getCurrentUser();

    GafGaffUser user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    messageUserUIDs = await _repository.fetchUserMessagesID(currentUser);

    for (var i = 0; i < messageUserUIDs.length; i++) {
      this.user = await _repository.fetchUserDetailsById(messageUserUIDs[i]);
      usersList.add(this.user);

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          messageUser = usersList[i];
        });
      }
    }
    // fetchUnreadMessageTotal();
  }

  fetchUnreadMessageTotal() async {
    final messageState = Provider.of<MessageState>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid");
    int tmpUnSeenCount = 0;
    int tmpSeenCount = 0;
    QuerySnapshot _chat;
    QuerySnapshot _messgae = await _firestore
        .collection("users")
        .doc(uid)
        .collection("message")
        .get();

    for (int i = 0; i < _messgae.docs.length; i++) {
      _chat = await _firestore
          .collection("users")
          .doc(uid)
          .collection("message")
          .doc(_messgae.docs[i].id)
          .collection("chat")
          .orderBy("timestamp", descending: true)
          .get();

      for (int i = 0; i < _chat.docs.length; i++) {
        if (_chat.docs[i].data()["status"] == "unread") {
          setState(() {
            tmpUnSeenCount += 1;
          });
        } else {
          setState(() {
            tmpSeenCount += 1;
          });
        }
      }
    }

    messageState.setTotalUnseenMessage(tmpUnSeenCount);

    // * MESSAGE REQUEST
    _repository.fetchMessageRequest(uid, context);

    print("total unseen message: ${messageState.totalMessage}");
    print("total tmp unseen message: $tmpUnSeenCount");
  }

  @override
  Widget build(BuildContext context) {
    return
        // * USER CHAT CARD
        buildUserChatList();
  }

  // * USER CHAT CARD
  Expanded buildUserChatList() {
    bool isMessageRead = true;
    return Expanded(
      child: messageUsersList.length == 0
          ? Center(
              child: Text("No Conversation"),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: messageUsersList.length,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser.uid)
                      .collection("message")
                      .doc(messageUsersList[index].uid)
                      .collection("chat")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // Timestamp _timestamp = _document[0].data["timestamp"];
                    // DateTime _dateTime = _timestamp.toDate();
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> _document =
                          snapshot.data.documents;

                      String data;
                      if (_document[0].data()["message"] != null) {
                        String value = _document[0].data()["message"];
                        if (value.length > 15) {
                          data = value.substring(0, 15) + "...";
                        } else {
                          data = value.substring(0, value.length);
                        }
                      } else {
                        data =
                            "${messageUsersList[index].displayName} sent image";
                      }

                      if (_document[0].data()["status"] == "unread") {
                        isMessageRead = true;
                      } else {
                        isMessageRead = false;
                      }

                      return Container(
                        child: Card(
                          color: isMessageRead ? Colors.grey.shade100 : null,
                          elevation: 0.4,
                          margin: EdgeInsets.all(0.0),
                          child: InkWell(
                            onLongPress: () {
                              _showBottomSheet(
                                  context, messageUsersList[index].uid, index);
                            },
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: ((context) => ChatDetailScreen(
                              //           photoUrl:
                              //               messageUsersList[index].photoUrl,
                              //           name:
                              //               messageUsersList[index].displayName,
                              //           receiverUid:
                              //               messageUsersList[index].uid,
                              //         )),
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //* chat card
                                  Container(
                                    child: Row(
                                      children: [
                                        //* image
                                        Container(
                                          width: 55,
                                          height: 55,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(
                                                messageUsersList[index]
                                                    .photoUrl),
                                          ),
                                        ),

                                        // * name
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(messageUsersList[index]
                                                  .displayName),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("$data "),
                                                      timeShow(_document[0]
                                                          .data()["timestamp"]),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),

                                                  // *  IF LATEST MESSAGE IS UN-READ THEN SHOW A NEW-MESSAGE-TAG
                                                  _document[0].data()[
                                                              "status"] ==
                                                          "unread"
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 2, 5, 2),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: Colors
                                                                  .red[200]),
                                                          child: Text('New',
                                                              style: TextStyle(
                                                                  fontSize: 8)),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
    );
  }

  //confirmation dialog
  void deleteChat(BuildContext context, String receiverUid, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to delete this conversation?'),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    //* SHOWING DIALOG TO USER
                    Dialogs()..getDialog(context);

                    // * DELETING USER CHAT HISTORY
                    _repository.deleteUsersChatHistory(
                        currentUser, receiverUid);

                    // * DELETING USER FROM LIST
                    setState(() {
                      messageUsersList.removeAt(index);
                    });

                    // * DELETING USER FROM MESSAGE COLLECTION
                    _firestore
                        .collection("users")
                        .doc(currentUser.uid)
                        .collection("message")
                        .doc(receiverUid)
                        .delete()
                        .then((value) async {
                      print("delete chat history");
                      Navigator.of(keyContext.currentContext).pop();
                      // * CLOSING BOTTOM SHEET
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  },
                  icon: Icon(Icons.delete_forever),
                  label: Text('Delete')),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  label: Text('Cancel'))
            ],
          );
        });
  }

  Future _showBottomSheet(BuildContext context, String receiverUid, int index) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            // * DELETING CONVERSATION
            Container(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () => deleteChat(context, receiverUid, index),
                child: Container(
                  margin: EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    trailing: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // * ARCHIVE CONVERSATION
            Container(
              margin: EdgeInsets.all(0),
              child: InkWell(
                onTap: () async {
                  // *
                  // * ARCHIVE CONVERSATION (BOOLEAN)😋😎
                  _firestore
                      .collection("users")
                      .doc(currentUser.uid)
                      .collection("message")
                      .doc(receiverUid)
                      .update({"isarchived": true}).then((value) {
                    print("updated");
                  });

                  // * DELETING USER FROM LIST
                  setState(() {
                    messageUsersList.remove(messageUsersList[index]);
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Text(
                      "Archive",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    trailing: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.archive,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget timeShow(dynamic timefromDB) {
    var databaseTime = timefromDB.toDate();
    var time = databaseTime.toString();
    final dateToday = DateTime.now();
    var dateFormate = DateFormat("dd MMM").format(DateTime.parse(time));
    var timeGet = DateFormat(" HH:MM a").format(DateTime.parse(time));
    var diffTime = dateToday.difference(databaseTime);
    var timeshow = '';

    if (diffTime.inHours < 24) {
      timeshow = timeGet;
    }
    if (diffTime.inHours >= 24) {
      timeshow = 'Yesterday';
    }
    if (diffTime.inHours >= 48) {
      timeshow = ' $timeGet \n $dateFormate';
    }

    return Text(
      timeshow,
      style: timeStyle,
    );
  }
}
