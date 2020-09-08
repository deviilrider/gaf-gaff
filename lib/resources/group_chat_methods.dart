import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/models/contact.dart';
import 'package:gafgaff/models/fcm.dart';
import 'package:gafgaff/models/group.dart';
import 'package:gafgaff/models/message.dart';
import 'package:meta/meta.dart';

class GroupChatMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _groupCollections =
      _firestore.collection(GROUP_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addMessageToDb(Message message, BuildContext context) async {
    var map = message.toMap();

    // await _groupCollections
    //     .document(message.receiverId)
    //     .collection("messages")
    //     .add(map);

    // addGroup(senderId: message.senderId, groupId: message.receiverId);

    // // * FETCHING USER FCM-TOKEN
    // fetchUserFcmToken(message.receiverId).then((value) {
    //   print("$value");
    //   // * SENDING NOTIFICATION
    //   // setState(() {
    //   //   if (type == 0) {
    //   //     messageContent = content;
    //   //   } else if (type == 1) {
    //   //     messageContent = '$displayName send you a photo.';
    //   //   } else {
    //   //     messageContent = '$displayName send you a sticker.';
    //   //   }
    //   // });

    //   FcmNotification()
    //     ..fcmSendMessage(value,
    //             receiverId: message.receiverId, context: context)
    //         .then((value) {
    //       print("Message Notification Successfully Sent");
    //     });
    // });

    return _groupCollections
        .document(message.receiverId)
        .collection("messages")
        .add(map);
  }

  Future<void> deleteMessageFromDb(
      String uid, String receiverId, BuildContext context) async {
    var delete = await _groupCollections
        .document(uid)
        .collection(receiverId)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    _userCollection
        .document(uid)
        .collection(CONTACTS_COLLECTION)
        .document(receiverId)
        .delete();

    return delete;
  }

  Future<void> setMessageRead({String senderId, String receiverId}) async {
    var setRead = await _groupCollections
        .document(senderId)
        .collection(receiverId)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({"status": 'read'});
      }
    });
    return setRead;
  }

  Future fetchUserFcmToken(String ownerUid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("users").document(ownerUid).get();
    return snapshot.data["fcmToken"];
  }

  DocumentReference getGroupsDocument({String of, String groupID}) =>
      _userCollection.document(of).collection("myGroups").document(groupID);

  addGroup({String senderId, String groupId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, groupId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String groupId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getGroupsDocument(of: senderId, groupID: groupId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: groupId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getGroupsDocument(of: senderId, groupID: groupId)
          .setData(receiverMap);
    }
  }

  void setImageMsgToGroup(String url, String groupID, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "Photo message.",
        receiverId: groupID,
        senderId: senderId,
        photoUrl: url,
        status: "unread",
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _groupCollections.document(groupID).collection("messages").add(map);

    _groupCollections.document(groupID).collection("messages").add(map);
  }

  Stream<QuerySnapshot> fetchGroupsMine({String userId}) =>
      _userCollection.document(userId).collection("myGroups").snapshots();

  Future<Group> getGroupDetails(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _groupCollections.document(id).get();
      return Group.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String groupID,
  }) =>
      _groupCollections
          .document(groupID)
          .collection("messages")
          .orderBy("timestamp")
          .snapshots();

  // Stream<QuerySnapshot> fetchMessageSeenStatus({
  //   @required String senderId,
  //   @required String groupID,
  // }) =>
  //     _groupCollections
  //         .document(groupID)
  //         .collection("messages")
  //         .orderBy("timestamp")
  //         .where("receiverId", isEqualTo: senderId)
  //         .snapshots();
}
