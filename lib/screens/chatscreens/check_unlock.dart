import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/models/contact.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/resources/chat_methods.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class CheckLockMessage extends StatelessWidget {
  final User receiver;

  CheckLockMessage({
    this.receiver,
  });

  TextEditingController enterCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return PickupLayout(
      scaffold: Scaffold(
        body: SafeArea(
            child: Center(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(USERS_COLLECTION)
                    .document(userProvider.getUser.uid)
                    .collection(CONTACTS_COLLECTION)
                    .where("contact_id", isEqualTo: receiver.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docList = snapshot.data.documents;

                    if (docList.isEmpty) {
                      print('empty contact details');
                    }
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        Contact contact = Contact.fromMap(docList[index].data);

                        return Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "This conversation is locked. Please enter lock code for this conversation.",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  TextField(
                                    controller: enterCodeController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Enter lock code'),
                                  ),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                          onPressed: () {
                                            contact.lockCode ==
                                                    enterCodeController.text
                                                ? Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                        receiver: receiver,
                                                      ),
                                                    ))
                                                : ALertDialogs().getErrorDialog(
                                                    context,
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
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          ),
        )),
      ),
    );
  }
}
