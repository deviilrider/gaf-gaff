import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/fcm.dart';
import 'package:gafgaff/models/user.dart';

class FollowUnfollowButton extends StatefulWidget {
  final String currentUserId;
  final String ownerUID;
  final String followingUserId;
  final bool tile;

  const FollowUnfollowButton(
      {Key key,
      @required this.currentUserId,
      @required this.followingUserId,
      this.tile = false,
      @required this.ownerUID})
      : super(key: key);

  @override
  _FollowUnfollowButtonState createState() => _FollowUnfollowButtonState();
}

class _FollowUnfollowButtonState extends State<FollowUnfollowButton> {
  var _repository = Repository();
  bool isFollowing = false;
  GafGaffUser currentuser;

  @override
  void initState() {
    if (mounted) {
      setUserFollowing(widget.ownerUID);
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
    bool follow =
        await _repository.checkIsFollowing(ownerUID, widget.currentUserId);
    setState(() {
      isFollowing = follow;
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
            title: Text(isFollowing ? "Unfollow Writer" : 'Follow Writer'),
            leading: Icon(Icons.rss_feed),
          )
        : isFollowing
            ? InkWell(
                onTap: () {
                  unfollowUser();
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              )
            : RaisedButton(
                child: Text("Follow"),
                color: Colors.deepPurple,
                // borderColor: Colors.transparent,
                textColor: Colors.white,
                onPressed: () {
                  followUser();
                  notifyUser();
                },
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
                "${this.currentuser.displayName} started following you",
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
