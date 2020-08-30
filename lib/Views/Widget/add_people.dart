import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/fcm.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:gafgaff/models/user.dart';

class AddPeopleTile extends StatefulWidget {
  final String currentUserId;
  final String followingUserId;
  final bool tile;

  const AddPeopleTile({
    Key key,
    @required this.currentUserId,
    @required this.followingUserId,
    this.tile = false,
  }) : super(key: key);

  @override
  _AddPeopleTileState createState() => _AddPeopleTileState();
}

class _AddPeopleTileState extends State<AddPeopleTile> {
  var _repository = Repository();
  bool isFollowing = false;
  bool isBackFollowing = false;
  GafGaffUser currentuser;

  @override
  void initState() {
    if (mounted) {
      setUserFollowing(widget.currentUserId);
    }

    super.initState();
    currentUser();
  }

  currentUser() {
    _repository.getCurrentUser().then((currentUser) async {
      GafGaffUser user = await _repository.retrieveUserDetails(currentUser);
      setState(() {
        this.currentuser = user;
      });
    });
  }

  Future setUserFollowing(String ownerUID) async {
    bool follow = await _repository.checkIsFollowing(
        widget.currentUserId, widget.followingUserId);
    setState(() {
      isFollowing = follow;
    });

    bool backFollow = await _repository.checkIsBackFollowing(
        widget.currentUserId, widget.followingUserId);
    setState(() {
      isBackFollowing = backFollow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.tile
        ? ListTile(
            onTap: () {
              if (isFollowing) {
                unfollowUser();
              } else {
                followUser();
              }
            },
            title: Text(isFollowing ? "Delete" : 'Add'),
            leading: Icon(Icons.rss_feed),
          )
        : isFollowing
            ? isBackFollowing
                ? ListTile(
                    onTap: () {
                      // unfollowUser();
                      ALertDialogs()
                        ..getErrorDialog(
                            context, "Users hasn't added you back");
                    },
                    title: Text('Connected'),
                    leading: CircleAvatar(child: Icon(Icons.verified_user)))
                : ListTile(
                    onTap: () {
                      ALertDialogs()
                        ..getErrorDialog(
                            context, "Users hasn't added you back");
                    },
                    title: Text('Pending Add Request'),
                    leading: CircleAvatar(child: Icon(Icons.person_add)),
                  )
            : ListTile(
                onTap: () {
                  followUser();
                  notifyUser();
                  ALertDialogs()
                    ..getErrorDialog(context, "Add Request is Sent");
                },
                title: Text('Add To Contacts'),
                leading: CircleAvatar(child: Icon(Icons.person_add)),
              );
  }

  followUser() {
    print('following user');
    _repository
        .followUser(
      currentUserId: widget.currentUserId,
      followingUserId: widget.followingUserId,
    )
        .then((value) {
      print(this.currentuser.displayName);
      _repository.fetchUserFcmToken(widget.followingUserId).then((value) {
        // fcmSendandReceive(value, widget.currentUser);

        if (value != null) {
          // * SEND PUSH-NOTIFICATION TO POST-OWNER
          print("FCMTOKEN: $value");
          FcmNotification()
            ..fcmSendToCurrentUser(value, "Follow",
                "${this.currentuser.displayName} added you. Accept add request.",
                type: "widgetType",
                docID: "postOwnerInfo.reference.documentID");
        } else {
          print("This post owner has null-token 😎");
        }
        // FcmNotification()..fcmSendLikes(value, currentUser, "Posts");
      });
    });
    setState(() {
      isFollowing = true;
    });
  }

  notifyUser() {
    print("notify user ${widget.currentUserId}");
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.followingUserId)
        .collection("follownotification")
        .doc(widget.currentUserId)
        .set({
      "displayName": currentuser.displayName,
      "photoUrl": currentuser.photoUrl,
      "status": "unread",
      "time": FieldValue.serverTimestamp(),
      "uid": currentuser.uid
    });
  }

  unfollowUser() {
    _repository.unFollowUser(
        currentUserId: widget.currentUserId,
        followingUserId: widget.followingUserId);
    setState(() {
      isFollowing = false;
    });
  }
}
