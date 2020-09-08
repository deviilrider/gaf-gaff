import 'package:flutter/material.dart';
import 'package:gafgaff/models/fcm.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/resources/chat_methods.dart';
import 'package:gafgaff/resources/contacts_methods.dart';
import 'package:gafgaff/widgets/circular_button.dart';
import 'package:gafgaff/widgets/dialogs.dart';

class AddDeleteRequestButton extends StatefulWidget {
  final User contactUser;
  final User currentUser;
  final bool tile;

  const AddDeleteRequestButton(
      {@required this.contactUser, this.currentUser, this.tile = false});
  @override
  _AddDeleteRequestButtonState createState() => _AddDeleteRequestButtonState();
}

class _AddDeleteRequestButtonState extends State<AddDeleteRequestButton> {
  bool isAdded = false;

  @override
  void initState() {
    setUserFollowing(widget.currentUser.uid);

    super.initState();
  }

  Future setUserFollowing(String ownerUID) async {
    bool follow =
        await ContactMethods().checkAdded(ownerUID, widget.contactUser.uid);
    setState(() {
      isAdded = follow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.tile
        ? CircularButton(
            onTap: () {
              if (isAdded) {
                ALertDialogs().responsiveDialog(context,
                    "Remove ${widget.contactUser.name} from contact list?", () {
                  removeUser();
                });
              } else {
                addUser();
              }
            },
            icon: isAdded ? Icons.link_off : Icons.person_add,
          )
        : isAdded
            ? ListTile(
                onTap: () {
                  ALertDialogs()
                      .responsiveDialog(
                          context,
                          "Remove ${widget.contactUser.name} from contact list?",
                          () => removeUser())
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                title: Text('Remove From Contacts'),
                leading: CircleAvatar(child: Icon(Icons.link_off)))
            : ListTile(
                onTap: () {
                  addUser();
                },
                title: Text('All To Contacts'),
                leading: CircleAvatar(child: Icon(Icons.person_add)));
  }

  addUser() {
    print('adding user');
    ContactMethods()
        .addUser(
            currentUserId: widget.currentUser.uid,
            contactUserId: widget.contactUser.uid)
        .then((value) {
      print(widget.currentUser.name);
      ChatMethods().fetchUserFcmToken(widget.contactUser.uid).then((value) {
        // fcmSendandReceive(value, widget.currentUser);

        if (value != null) {
          // * SEND PUSH-NOTIFICATION TO POST-OWNER
          print("FCMTOKEN: $value");
          FcmNotification()
            ..fcmSendToAddedUser(value, "${widget.currentUser.name}",
                "added you to contacts.", widget.currentUser.uid);
        } else {
          print("This post owner has null-token 😎");
        }
        // FcmNotification()..fcmSendLikes(value, currentUser, "Posts");
      });
    });
    setState(() {
      isAdded = true;
    });
  }

  removeUser() {
    ContactMethods()
        .removeUser(
            currentUserId: widget.currentUser.uid,
            contactUserId: widget.contactUser.uid)
        .then((value) {
      setState(() {
        isAdded = false;
      });
      Navigator.pop(context);
    });
  }
}
