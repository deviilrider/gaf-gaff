import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:gafgaff/StateManagement/messageRequestState.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/like.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GoogleSignIn _googleSignIn;
  GafGaffUser user, _userauth;
  Like like;
  Message _message;
  StorageReference _storageReference;

  Future<List<String>> getBlockedUids(User user) async {
    QuerySnapshot blockedUsers = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("blockedUsers")
        .get();

    List<String> blockedUids = [];

    if (blockedUsers.docs.length >= 1) {
      for (var x in blockedUsers.docs) {
        blockedUids.add(x.data()['uid']);
      }
    }

    return blockedUids;
  }

  Future<void> addDataToDb(User currentUser, BuildContext context) async {
    _firestore
        .collection("display_names")
        .doc(currentUser.displayName)
        .set({'displayName': currentUser.displayName});

    user = GafGaffUser(
      uid: currentUser.uid,
      phone: currentUser.phoneNumber,
      displayName: currentUser.displayName,
      photoUrl: currentUser.photoURL,
      fcmToken: await _firebaseMessaging.getToken(),
    );
    print("User notification token added");

    return _firestore
        .collection("users")
        .doc(currentUser.uid)
        .set(user.toMap());
  }

  Future<void> updateUserToken(User currentUser) async {
    user = GafGaffUser(
      uid: currentUser.uid,
      phone: currentUser.phoneNumber,
      displayName: currentUser.displayName,
      photoUrl: currentUser.photoURL,
      fcmToken: await _firebaseMessaging.getToken(),
    );
    _firestore.collection("users").doc(currentUser.uid).set(
          user.toMap(),
        );
  }

  Future<User> signInEmail(
      String email, String password, BuildContext context) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;

    return user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkGafGaffUser(String phone) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .where("phone", isEqualTo: phone)
        .get();
    if (querySnapshot.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signUpEmail(String email, String password, String displayName,
      String photoUrl, BuildContext context) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    _firestore
        .collection("display_names")
        .doc(displayName)
        .set({'displayName': displayName});

    _userauth = GafGaffUser(
      uid: user.uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
    );

    return _firestore.collection("users").doc(user.uid).set(_userauth.toMap());
  }

  // ignore: missing_return
  Future<bool> checkUserexistance(String email) async {
    _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .whenComplete(() {
      return true;
    });
  }

  Future<bool> authenticateUser(User user) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    if (currentUser == null) {
    } else {}

    return currentUser;
  }

  Future<void> signOut() async {
    if (_googleSignIn != null) {
      await _googleSignIn.disconnect().whenComplete(() async {
        await _googleSignIn.signOut();
        await _auth.signOut();
      });
    } else {
      await _auth.signOut();
    }
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<List<DocumentSnapshot>> fetchPendingNotification(
      String ownerUid, DocumentReference reference) async {
    QuerySnapshot qrySnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerUid)
        .collection("notifications")
        .where("docRef", isEqualTo: reference)
        .where("isnotificationsend", isEqualTo: "false")
        .where("like", isEqualTo: "true")
        .get();

    print(qrySnap.docs.length);
    return qrySnap.docs;
  }

  Future<GafGaffUser> retrieveUserDetails(User user) async {
    DocumentSnapshot _docsnapshot =
        await _firestore.collection("users").doc(user.uid).get();
    return GafGaffUser.fromMap(_docsnapshot.data());
  }

  Future<GafGaffUser> retrieveUserDetailsList(String user) async {
    DocumentSnapshot _docsnapshot =
        await _firestore.collection("users").doc(user).get();
    return GafGaffUser.fromMap(_docsnapshot.data());
  }

  Future fetchUserFcmToken(String ownerUid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(ownerUid)
        .get();
    return snapshot.data()["fcmToken"];
  }

  Future deleteUsersChatHistory(
      GafGaffUser currentUser, String receiverUid) async {
    // * FETCHINNG CHAT HISTORY OF USER
    QuerySnapshot _chat = await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("message")
        .doc(receiverUid)
        .collection("chat")
        .get();

    for (int i = 0; i < _chat.docs.length; i++) {
      // * DELETING USER CHAT HISTORY
      _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("message")
          .doc(receiverUid)
          .collection("chat")
          .doc(_chat.docs[i].id)
          .delete();
    }
  }

  Future<bool> checkIfUserLikedOrNot(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection("likes").doc(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<bool> checkIfUserLikedOrNotA(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection("likes").doc(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<List<String>> fetchAllUserNames(User user) async {
    List<String> userNameList = List<String>();
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userNameList.add(querySnapshot.docs[i].data()['displayName']);
      }
    }
    return userNameList;
  }

  Future<String> fetchUidBySearchedName(String name) async {
    String uid;
    List<DocumentSnapshot> uidList = List<DocumentSnapshot>();

    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      uidList.add(querySnapshot.docs[i]);
    }

    for (var i = 0; i < uidList.length; i++) {
      if (uidList[i].data()['displayName'] == name) {
        uid = uidList[i].id;
      }
    }
    return uid;
  }

  Future<GafGaffUser> fetchUserDetailsById(String uid) async {
    DocumentSnapshot docsnapshot =
        await _firestore.collection("users").doc(uid).get();
    return GafGaffUser.fromMap(docsnapshot.data());
  }

  Future<void> followUser(
      {String currentUserId, String followingUserId}) async {
    var followingMap = Map<String, String>();
    followingMap['uid'] = followingUserId;
    await _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("following")
        .doc(followingUserId)
        .set(followingMap);

    var followersMap = Map<String, String>();
    followersMap['uid'] = currentUserId;

    return _firestore
        .collection("users")
        .doc(followingUserId)
        .collection("followers")
        .doc(currentUserId)
        .set(followersMap);
  }

  Future<void> unFollowUser(
      {String currentUserId, String followingUserId}) async {
    await _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("following")
        .doc(followingUserId)
        .delete();

    return _firestore
        .collection("users")
        .doc(followingUserId)
        .collection("followers")
        .doc(currentUserId)
        .delete();
  }

  Future<bool> checkIsFollowing(String ownerUID, String currentUserId) async {
    bool isFollowing = false;
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("following")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == ownerUID) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  Future<String> fetchNotificationCount(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .where("status", isEqualTo: 'unread')
        .get();
    // return snapshot.docs.length.toString();
    return snapshot.docs.length.toString();
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['photoUrl'] = photoUrl;
    return _firestore.collection("users").doc(uid).update(map);
  }

  Future<void> updateDetails(String uid, String name, String phone) async {
    Map<String, dynamic> map = Map();
    map['displayName'] = name;
    map['phone'] = phone;

    return _firestore.collection("users").doc(uid).update(map);
  }

  Future<List<String>> fetchUserNames(User user) async {
    DocumentReference documentReference =
        _firestore.collection("messages").doc(user.uid);
    List<String> userNameList = List<String>();
    List<String> chatUsersList = List<String>();
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        print("USERNAMES : ${querySnapshot.docs[i].id}");
        userNameList.add(querySnapshot.docs[i].id);
        //querySnapshot.docs[i].reference.collection("collectionPath");
        //userNameList.add(querySnapshot.docs[i].data()['displayName']);
      }
    }

    for (var i = 0; i < userNameList.length; i++) {
      if (documentReference.collection(userNameList[i]) != null) {
        if (documentReference.collection(userNameList[i]).get() != null) {
          print("CHAT USERS : ${userNameList[i]}");
          chatUsersList.add(userNameList[i]);
        }
      }
    }

    print("CHAT USERS LIST : ${chatUsersList.length}");

    return chatUsersList;

    // print("USERNAMES LIST : ${userNameList.length}");
    // return userNameList;
  }

  Future<List<GafGaffUser>> fetchAllUsers(User user) async {
    List<GafGaffUser> userList = List<GafGaffUser>();
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(GafGaffUser.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.docs[i].data()[User.fromMap(mapData)]);
      }
    }
    return userList;
  }

  Future<List<GafGaffUser>> fetchAllUsersFollowed(User user) async {
    List<GafGaffUser> userList = List<GafGaffUser>();
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(GafGaffUser.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.docs[i].data()[User.fromMap(mapData)]);
      }
    }
    return userList;
  }

  Future<List<GafGaffUser>> fetchMessagedUser(User user) async {
    List<GafGaffUser> userList = List<GafGaffUser>();

    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("message")
        // .where("isarchived", isEqualTo: false)
        // .where("isfollowing", isEqualTo: true)
        .snapshots()
        .listen((event) async {
      // event.docs.forEach((element) async {
      //   QuerySnapshot querySnapshot = await _firestore
      //       .collection("users")
      //       .doc(user.uid)
      //       .collection("following")
      //       .where("uid", isEqualTo: element.id)
      //       .get();

      //   if (querySnapshot.docs.length > 0) {
      //     print("${querySnapshot.docs[0].data()["uid"]} Found");
      //     _firestore
      //         .collection("users")
      //         .doc(element.id)
      //         .snapshots()
      //         .listen((event) {
      //       // userList.clear();
      //       print(event.data()["displayName"]);
      //       userList.add(GafGaffUser.fromMap(event.data()));
      //     });
      //   } else {
      //     print("Not Found");
      //   }
      // });
    });

    return userList;
  }

  Future<List<GafGaffUser>> fetchMessageRequest(
      String userUid, BuildContext context) async {
    final messageRequest = Provider.of<MessageRequestState>(context);
    List<String> _followingList = [];
    List<GafGaffUser> _messageList = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(userUid)
        .collection("following")
        .get();

    // * COLLECTING ALL FOLLOWING OF USER IN LIST
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      _followingList.add(querySnapshot.docs[i].id);
    }

    QuerySnapshot messageQuerySnapshot = await _firestore
        .collection("users")
        .doc(userUid)
        .collection("message")
        .get();

    messageRequest.clearTotalMessageRequest();

    // * SEARCHING IF FOLLOWING LIST CONTAINS VALUE
    for (int i = 0; i < messageQuerySnapshot.docs.length; i++) {
      if (!_followingList.contains(messageQuerySnapshot.docs[i].id)) {
        // _messageList.add(messageQuerySnapshot.docs[i].documentID);
        DocumentSnapshot userQuerySnapshot = await _firestore
            .collection("users")
            .doc(messageQuerySnapshot.docs[i].id)
            .get();

        _messageList.add(GafGaffUser.fromMap(userQuerySnapshot.data()));
        messageRequest.setTotalMessageRequestValue(_messageList.length);

        // ! IF ABOVE CODE SHOWS ERROR THEN UNCOMMENT BELOW CODE
        // _firestore
        //     .collection("users")
        //     .doc(messageQuerySnapshot.docs[i].documentID)
        //     .snapshots()
        //     .listen((event) {
        //   _messageList.add(User.fromMap(event.data));
        //   messageRequest.setTotalMessageRequest();
        // });
      }
    }

    print("Following List: ${_followingList.length}");
    print("Message Request List: ${_messageList.length}");
    return _messageList;
  }

  Future<List<String>> fetchUserMessagesID(User user) async {
    List<String> messageUserUIDs = List<String>();

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("message")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        messageUserUIDs.add(querySnapshot.docs[i].id);
        //userList.add(querySnapshot.docs[i].data()[User.fromMap(mapData)]);
      }
    }
    return messageUserUIDs;
  }

  void uploadImageMsgToDb(String url, String receiverUid, String senderuid) {
    _message = Message.withoutMessage(
      receiverUid: receiverUid,
      senderUid: senderuid,
      photoUrl: url,
      timestamp: FieldValue.serverTimestamp(),
      type: 'image',
    );

    // * FOR SENDER COLLECTION
    var senderMap = Map<String, dynamic>();
    senderMap['senderUid'] = _message.senderUid;
    senderMap['receiverUid'] = _message.receiverUid;
    senderMap['type'] = _message.type;
    senderMap['status'] = "read";
    senderMap['timestamp'] = _message.timestamp;
    senderMap['photoUrl'] = _message.photoUrl;

    // * FOR RECEIVER COLLECTION
    var receiverMap = Map<String, dynamic>();
    receiverMap['senderUid'] = _message.senderUid;
    receiverMap['receiverUid'] = _message.receiverUid;
    receiverMap['type'] = _message.type;
    receiverMap['status'] = "unread";
    receiverMap['timestamp'] = _message.timestamp;
    receiverMap['photoUrl'] = _message.photoUrl;

    // * SAVING TO SENDER COLLECTION
    _firestore
        .collection("users")
        .doc(_message.senderUid)
        .collection("message")
        .doc(receiverUid)
        .collection("chat")
        .add(senderMap)
        .whenComplete(() {});

    // * SAVING TO RECEIVER COLLECTION
    _firestore
        .collection("users")
        .doc(receiverUid)
        .collection("message")
        .doc(_message.senderUid)
        .collection("chat")
        .add(receiverMap)
        .whenComplete(() {});
  }

  Future<void> addMessageToDb(Message sendermessage, Message receiverMessage,
      String receiverUid, bool isFollowed) async {
    print("Message : ${sendermessage.message}");
    var sendermap = sendermessage.toMap();
    var receivermap = receiverMessage.toMap();

    print("Map : $sendermessage");

    await _firestore
        .collection("users")
        .doc(sendermessage.senderUid)
        .collection("message")
        .doc(receiverUid)
        .set(
      {
        "receiverid": receiverUid,
        "isarchived": false,
      },
    );

    if (isFollowed) {
      await _firestore
          .collection("users")
          .doc(receiverUid)
          .collection("message")
          .doc(receiverMessage.senderUid)
          .set(
        {
          "senderid": receiverMessage.senderUid,
          "isarchived": false,
        },
      ); // * small change to receiver collection
    } else {
      await _firestore
          .collection("users")
          .doc(receiverUid)
          .collection("message")
          .doc(receiverMessage.senderUid)
          .set(
        {
          "senderid": receiverMessage.senderUid,
          "isarchived": false,
        },
      ); // * small change to receiver collection
    }

    // await _firestore
    //     .collection("users")
    //     .doc(receiverUid)
    //     .collection("message")
    //     .doc(receiverMessage.senderUid)
    //     .set({"senderid": receiverMessage.senderUid, "isarchived": false}, merge: true); // * small change to receiver collection

    // * SAVING TO SENDER COLLECTION
    await _firestore
        .collection("users")
        .doc(sendermessage.senderUid)
        .collection("message")
        .doc(receiverUid)
        .collection("chat")
        .add(sendermap);

    // * SAVING TO RECEIVER COLLECTION
    return _firestore
        .collection("users")
        .doc(receiverUid)
        .collection("message")
        .doc(receiverMessage.senderUid)
        .collection("chat")
        .add(receivermap);
  }

  Future<void> changeUnreadMessage(User user, String receiverUid) async {
    // * CHECKING IF ANY UNREAD MESSAGE
    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("message")
        .doc(receiverUid)
        .collection("chat")
        .where("status", isEqualTo: "unread")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        _firestore
            .collection("users")
            .doc(user.uid)
            .collection("message")
            .doc(receiverUid)
            .collection("chat")
            .doc(element.id)
            .update({
          "status": "read",
        });
      });
    });
  }

  Future<List<String>> fetchUsersFCMToken(
      String ownerUid, DocumentReference reference) async {
    List<String> _likeList = [];
    List<String> _followerFCM = [];

    // * FETCHING POST LIKES
    QuerySnapshot _likeSnapshot = await reference.collection("likes").get();

    for (int i = 0; i < _likeSnapshot.docs.length; i++) {
      _likeList.add(_likeSnapshot.docs[i].data()["ownerUid"]);
    }

    // * FETCHING POST COMMENTS
    QuerySnapshot _commentSnapshot =
        await reference.collection("comments").get();

    for (int i = 0; i < _commentSnapshot.docs.length; i++) {
      if (!_likeList.contains(_commentSnapshot.docs[i].data()["ownerUid"])) {
        _likeList.add(_commentSnapshot.docs[i].data()["ownerUid"]);
      }
    }

    // * FETCHING USER-FOLLOWER
    // QuerySnapshot followerSnapshot = await Firestore.instance
    //     .collection("users")
    //     .doc(ownerUid)
    //     .collection("followers")
    //     .get();

    // for (int i = 0; i < followerSnapshot.docs.length; i++) {
    //   if (!_muteNotificationList
    //       .contains(followerSnapshot.docs[i].data()["uid"])) {
    //     _followerList.add(followerSnapshot.docs[i].data()["uid"]);
    //   }
    // }

    // * FETCHING UNMUTED USER FCM-TOKEN
    for (int i = 0; i < _likeList.length; i++) {
      if (_likeList[i] != ownerUid) {
        DocumentSnapshot userFcm = await Firestore.instance
            .collection("users")
            .doc(_likeList[i])
            .get();

        if (userFcm.data()["fcmToken"] != null) {
          _followerFCM.add(userFcm.data()["fcmToken"]);
        }
      }
    }

    return _followerFCM;
  }

  Future<List<String>> fetchFollowingUids(User user) async {
    List<String> followingUIDs = List<String>();

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("following")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followingUIDs.add(querySnapshot.docs[i].id);
    }

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DDDD : ${followingUIDs[i]}");
    }
    return followingUIDs;
  }

  Future<List<String>> fetchFollowerUids(User user) async {
    List<String> followerUIDs = List<String>();

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("followers")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followerUIDs.add(querySnapshot.docs[i].id);
    }

    for (var i = 0; i < followerUIDs.length; i++) {
      print("DDDD : ${followerUIDs[i]}");
    }
    return followerUIDs;
  }

  Future<List<String>> fetchFriendsFollowersByUids(String userUid) async {
    List<String> followerUids = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(userUid)
        .collection("followers")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      followerUids.add(querySnapshot.docs[i].id);
    }

    return followerUids;
  }

  Future<List<String>> fetchFriendsFollowingByUids(String userUid) async {
    List<String> followingUids = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(userUid)
        .collection("following")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      followingUids.add(querySnapshot.docs[i].id);
    }

    return followingUids;
  }

  Future<List<String>> fetchFollowingByUids(String userUid) async {
    List<String> followingUids = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .doc(userUid)
        .collection("following")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      followingUids.add(querySnapshot.docs[i].id);
    }

    return followingUids;
  }
}

//for articles
