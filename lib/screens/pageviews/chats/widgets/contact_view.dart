import 'package:flutter/material.dart';
import 'package:gafgaff/screens/chatscreens/check_unlock.dart';
import 'package:gafgaff/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:gafgaff/models/contact.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/resources/chat_methods.dart';
import 'package:gafgaff/screens/chatscreens/chat_screen.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/widgets/custom_tile.dart';

import 'last_message_container.dart';
import 'messageseenstatus.dart';
import 'online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
            contactData: contact,
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
  final User contact;
  final Contact contactData;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
    @required this.contactData,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return ListTile(
        leading: Container(
          constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
          child: Stack(
            children: <Widget>[
              contactData.isLocked
                  ? CircleAvatar(radius: 50, child: Icon(Icons.lock))
                  : CachedImage(
                      contact.profilePhoto,
                      radius: 50,
                      isRound: true,
                    ),
              OnlineDotIndicator(
                uid: contact.uid,
              ),
            ],
          ),
        ),
        title: Text(
          (contact != null ? contact.name : null) != null
              ? contactData.isLocked
                  ? "${contact.name.substring(0, 1)} * * * * * * "
                  : contact.name
              : "..",
        ),
        subtitle: contactData.isLocked
            ? Container(height: 10, width: 10, child: Text('****************'))
            : LastMessageContainer(
                stream: _chatMethods.fetchLastMessageBetween(
                  senderId: userProvider.getUser.uid,
                  receiverId: contact.uid,
                ),
              ),
        trailing: contactData.isLocked
            ? Container(
                height: 10,
                width: 10,
                child: Icon(
                  Icons.lock,
                  size: 14,
                ),
              )
            : MessageReadUnreadStatus(
                stream: _chatMethods.fetchMessageSeenStatus(
                  senderId: userProvider.getUser.uid,
                  receiverId: contact.uid,
                ),
              ),
        onTap: () {
          ChatMethods().setMessageRead(
            senderId: userProvider.getUser.uid,
            receiverId: contact.uid,
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckLockMessage(
                  receiver: contact,
                ),
              ));
        },
        onLongPress: () => showMessageOptions(context, contact, contactData));
  }

  showMessageOptions(
      BuildContext context, User receiver, Contact contact) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
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
            // * mark as unread
            Container(
              margin: EdgeInsets.all(0),
              child: InkWell(
                onTap: () async {
                  // // *
                  ChatMethods()
                      .markMessageAsUnread(
                          senderId: userProvider.getUser.uid,
                          receiverId: receiver.uid)
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Text(
                      "Mark as unread",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.mark_as_unread,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // * lock the chat
            Container(
              margin: EdgeInsets.all(0),
              child: InkWell(
                onTap: () async {
                  contact.isLocked
                      ? showUnlockDialog(context, contact, receiver.uid)
                      : showDialogs(context, receiver.uid);
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Text(
                      contact.isLocked
                          ? "Unlock this conversation"
                          : "Lock this conversation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          contact.isLocked ? Icons.lock : Icons.lock_open,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // * DELETING CONVERSATION
            Container(
              padding: EdgeInsets.all(2),
              child: InkWell(
                onTap: () {
                  ALertDialogs()
                    ..deleteConversation(
                        context, userProvider.getUser.uid, receiver.uid);
                },
                child: Container(
                  margin: EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Text(
                      "Delete Conversation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  // // *
                  // // * ARCHIVE CONVERSATION (BOOLEAN)😋😎
                  // _firestore
                  //     .collection("users")
                  //     .document(currentUser.uid)
                  //     .collection("message")
                  //     .document(receiverUid)
                  //     .updateData({"isarchived": true}).then((value) {
                  //   print("updated");
                  // });

                  // // * DELETING USER FROM LIST
                  // setState(() {
                  //   messageUsersList.remove(messageUsersList[index]);
                  // });
                  // Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Text(
                      "Archive Conversation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

//entermessage
  showDialogForCode(
      BuildContext context, Contact contact, User receiver) async {
    TextEditingController enterCodeController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter lock code for this conversation.",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    TextField(
                      controller: enterCodeController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Enter lock code'),
                    ),
                    SizedBox(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () {
                              contact.lockCode == enterCodeController.text
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          receiver: receiver,
                                        ),
                                      ))
                                  : ALertDialogs().getErrorDialog(context,
                                      "Lock Code doesn't matched, Try Again !!!");
                              ;
                            },
                            child: Text('Submit')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  showDialogs(BuildContext context, String receiverId) async {
    TextEditingController lockController = TextEditingController();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Do you want to lock this conversation?",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Enter lock fot this conversation. make sure you remeber the code',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextField(
                      controller: lockController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter lock code'),
                    ),
                    SizedBox(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () {
                              ChatMethods()
                                  .lockConversation(userProvider.getUser,
                                      lockController.text, receiverId)
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ALertDialogs()
                                  ..getSuccessDialog(context,
                                      "Conversation Locked. Remember your lock code for next time.");
                              });
                            },
                            child: Text('Lock')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  showUnlockDialog(
      BuildContext context, Contact contact, String receiverId) async {
    TextEditingController unlockController = TextEditingController();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Do you want to unlock this conversation?",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Once you unlock this conversation you can view chat without code.',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextField(
                      controller: unlockController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter lock code'),
                    ),
                    SizedBox(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () {
                              contact.lockCode == unlockController.text
                                  ? ChatMethods()
                                      .unlockConversation(
                                          userProvider.getUser, receiverId)
                                      .whenComplete(() {
                                      Navigator.pop(context);
                                      ALertDialogs()
                                        ..getSuccessDialog(context,
                                            "Conversation is unlocked. Anyone can view this conversation.");
                                    })
                                  : ALertDialogs().getErrorDialog(context,
                                      "Lock Code doesn't matched, Try Again !!!");
                              ;
                            },
                            child: Text('Unlock')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
