import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/user.dart';
import 'package:gafgaff/StateManagement/messageRequestState.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageRequest extends StatefulWidget {
  @override
  _MessageRequestState createState() => _MessageRequestState();
}

class _MessageRequestState extends State<MessageRequest> {
  List<GafGaffUser> messageUsersList = [];
  var _repository = Repository();
  GafGaffUser _user = GafGaffUser();
  List<GafGaffUser> usersList = List<GafGaffUser>();

  Widget timeShow(dynamic timefromDB) {
    var databaseTime = timefromDB.toDate();
    var time = databaseTime.toString();
    final dateToday = DateTime.now();
    var dateFormate = DateFormat("dd-MMMM-yy").format(DateTime.parse(time));
    var timeGet = DateFormat(" HH:MM a").format(DateTime.parse(time));
    var diffTime = dateToday.difference(databaseTime);
    var timeshow = '';

    if (diffTime.inHours < 24) {
      timeshow = timeGet;
    }
    if (diffTime.inHours >= 24) {
      timeshow = ' $timeGet \n Yesterday';
    }
    if (diffTime.inHours >= 48) {
      timeshow = ' $timeGet \n $dateFormate';
    }

    return Text(
      timeshow,
      style: TextStyle(
          fontSize: 9,
          color: Colors.grey.shade800,
          fontStyle: FontStyle.italic),
    );
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
                    // Timestamp _timestamp = _document[0].data()["timestamp"];
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
                                  //TODO chat card
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

                                                  // ! PREVIOUS MESSAGE STATUS CONTAINS NULL VALUE
                                                  // _document[0].data()["status"] ==
                                                  //         null
                                                  //     ? Container(
                                                  //         padding: EdgeInsets
                                                  //             .fromLTRB(
                                                  //                 5, 2, 5, 2),
                                                  //         decoration: BoxDecoration(
                                                  //             borderRadius:
                                                  //                 BorderRadius
                                                  //                     .circular(
                                                  //                         20),
                                                  //             color: Colors
                                                  //                 .red[200]),
                                                  //         child: Text('New',
                                                  //             style: TextStyle(
                                                  //                 fontSize: 8)),
                                                  //       )
                                                  //     : Container(),

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

                                              // * FOR TIMESTAMP OF USER-MESSAGE
                                              // StreamBuilder(
                                              //   stream: Firestore.instance
                                              //       .collection("users")
                                              //       .document(currentUser.uid)
                                              //       .collection("message")
                                              //       .document(
                                              //           messageUsersList[index]
                                              //               .uid)
                                              //       .collection("chat")
                                              //       .orderBy("timestamp",
                                              //           descending: true)
                                              //       .snapshots(),
                                              //   builder: (BuildContext context,
                                              //       AsyncSnapshot snapshot) {
                                              //     if (snapshot.hasData) {
                                              //       List<DocumentSnapshot>
                                              //           _document =
                                              //           snapshot.data.documents;
                                              //       // Timestamp _timestamp = _document[0].data()["timestamp"];
                                              //       // DateTime _dateTime = _timestamp.toDate();
                                              //       String data;
                                              //       if (_document[0]
                                              //               .data()["message"] !=
                                              //           null) {
                                              //         String value = _document[0]
                                              //             .data()["message"];
                                              //         if (value.length > 15) {
                                              //           data = value.substring(
                                              //                   0, 15) +
                                              //               "...";
                                              //         } else {
                                              //           data = value.substring(
                                              //               0, value.length);
                                              //         }
                                              //       } else {
                                              //         data =
                                              //             "${messageUsersList[index].displayName} sent image";
                                              //       }

                                              //       if (_document[0]
                                              //               .data()["status"] ==
                                              //           "unread") {
                                              //         isMessageRead = false;
                                              //       } else {
                                              //         isMessageRead = true;
                                              //       }

                                              //       return Row(
                                              //         mainAxisAlignment:
                                              //             MainAxisAlignment
                                              //                 .spaceBetween,
                                              //         children: [
                                              //           Row(
                                              //             mainAxisAlignment:
                                              //                 MainAxisAlignment
                                              //                     .start,
                                              //             children: [
                                              //               Text("$data "),
                                              //               timeShow(
                                              //                   _document[0].data()[
                                              //                       "timestamp"]),
                                              //             ],
                                              //           ),
                                              //           SizedBox(
                                              //             width: 20,
                                              //           ),

                                              //           // ! PREVIOUS MESSAGE STATUS CONTAINS NULL VALUE
                                              //           // _document[0].data()["status"] ==
                                              //           //         null
                                              //           //     ? Container(
                                              //           //         padding: EdgeInsets
                                              //           //             .fromLTRB(
                                              //           //                 5, 2, 5, 2),
                                              //           //         decoration: BoxDecoration(
                                              //           //             borderRadius:
                                              //           //                 BorderRadius
                                              //           //                     .circular(
                                              //           //                         20),
                                              //           //             color: Colors
                                              //           //                 .red[200]),
                                              //           //         child: Text('New',
                                              //           //             style: TextStyle(
                                              //           //                 fontSize: 8)),
                                              //           //       )
                                              //           //     : Container(),

                                              //           // *  IF LATEST MESSAGE IS UN-READ THEN SHOW A NEW-MESSAGE-TAG
                                              //           _document[0].data()[
                                              //                       "status"] ==
                                              //                   "unread"
                                              //               ? Container(
                                              //                   padding:
                                              //                       EdgeInsets
                                              //                           .fromLTRB(
                                              //                               5,
                                              //                               2,
                                              //                               5,
                                              //                               2),
                                              //                   decoration: BoxDecoration(
                                              //                       borderRadius:
                                              //                           BorderRadius
                                              //                               .circular(
                                              //                                   20),
                                              //                       color: Colors
                                              //                               .red[
                                              //                           200]),
                                              //                   child: Text('New',
                                              //                       style: TextStyle(
                                              //                           fontSize:
                                              //                               8)),
                                              //                 )
                                              //               : Container(),
                                              //         ],
                                              //       );
                                              //     } else {
                                              //       return Text(
                                              //           "No conversation");
                                              //     }
                                              //   },
                                              // )
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

  @override
  void initState() {
    super.initState();
    // retrieveUserDetail();
    _repository.getCurrentUser().then((user) {
      // * FETCHING ALL USER (DB)
      _repository.fetchAllUsers(user).then((updatedList) {
        setState(() {
          // * fetch all users
          usersList = updatedList.cast<GafGaffUser>();
        });
      });

      // * FETCH MESSAGED REQUEST USER
      _repository.fetchMessageRequest(user.uid, context).then((value) {
        setState(() {
          messageUsersList.clear();
          messageUsersList = value.cast<GafGaffUser>();
        });
      });
    });
    fetchUser();
  }

  fetchRequest() {}

  GafGaffUser currentUser, user, messageUser;
  String lastMessage;
  IconData icon;
  Color color;
  List<String> messageUserUIDs = List<String>();

  void fetchUser() async {
    User currentUser = await _repository.getCurrentUser();

    GafGaffUser user = (await _repository.fetchUserDetailsById(currentUser.uid))
        as GafGaffUser;
    setState(() {
      this.currentUser = user;
    });

    messageUserUIDs = await _repository.fetchUserMessagesID(currentUser);

    for (var i = 0; i < messageUserUIDs.length; i++) {
      this.user = (await _repository.fetchUserDetailsById(messageUserUIDs[i]))
          as GafGaffUser;
      usersList.add(this.user);

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          messageUser = usersList[i];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final messageRequest = Provider.of<MessageRequestState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Message request"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: size.width,
              // height: 70,
              child: Column(
                children: [
                  // * search ui button
                  // buildSearchButton(context),
                ],
              ),
            ),
            // * USER CHAT CARD
            buildUserChatList()
          ],
        ),
      ),
    );
  }
}
