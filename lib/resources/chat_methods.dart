import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/models/contact.dart';
import 'package:gafgaff/models/fcm.dart';
import 'package:gafgaff/models/message.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/widgets/message_search.dart';
import 'package:meta/meta.dart';

import 'auth_methods.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addMessageToDb(Message message, BuildContext context) async {
    var map = message.toMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    // * FETCHING USER FCM-TOKEN
    fetchUserFcmToken(message.receiverId).then((value) {
      print("$value");
      // * SENDING NOTIFICATION
      // setState(() {
      //   if (type == 0) {
      //     messageContent = content;
      //   } else if (type == 1) {
      //     messageContent = '$displayName send you a photo.';
      //   } else {
      //     messageContent = '$displayName send you a sticker.';
      //   }
      // });

      FcmNotification()
        ..fcmSendMessage(value,
                receiverId: message.receiverId, context: context)
            .then((value) {
          print("Message Notification Successfully Sent");
        });
    });

    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<void> deleteMessageFromDb(
      String uid, String receiverId, BuildContext context) async {
    var delete = await _messageCollection
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

  Future<void> deleteSelectedMessage(
      String uid, String receiverId, String docId) async {
    print(docId);
    await _messageCollection
        .document(uid)
        .collection(receiverId)
        .document(docId)
        .delete();

    return _messageCollection
        .document(uid)
        .collection(receiverId)
        .document(docId)
        .delete();
  }

  Future<void> deleteSelectMessageforReceiver(
      String uid, String receiverId, String message) async {
    var delete = await _messageCollection
        .document(receiverId)
        .collection(uid)
        .where("message", isEqualTo: message)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    return delete;
  }

  Future<void> setMessageRead({String senderId, String receiverId}) async {
    var setRead = await _messageCollection
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

  Future<void> markMessageAsUnread({String senderId, String receiverId}) async {
    var setUnread = await _messageCollection
        .document(senderId)
        .collection(receiverId)
        .getDocuments()
        .then((snapshot) {
      Message message = Message.fromMap(snapshot.documents.last.data);
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .where("timestamp", isEqualTo: message.timestamp)
          .getDocuments()
          .then((ss) {
        for (DocumentSnapshot ds in ss.documents) {
          ds.reference.updateData({"status": 'unread'});
        }
      });
    });
    return setUnread;
  }

  //search user
  searchMessage(BuildContext context, String receiverID) async {
    AuthMethods().getCurrentUser().then((FirebaseUser user) {
      fetchAllMessages(user, receiverID).then((List<Message> messageList) {
        showSearch(
            context: context,
            delegate: MessageSearch(messageList: messageList));
      });
    });
  }

  Future<List<Message>> fetchAllMessages(
      FirebaseUser currentUser, String receiverID) async {
    List<Message> messageList = List<Message>();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .document(currentUser.uid)
        .collection(receiverID)
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        messageList.add(Message.fromMap(querySnapshot.documents[i].data));
      }
    }
    return messageList;
  }

  Future fetchUserFcmToken(String ownerUid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("users").document(ownerUid).get();
    return snapshot.data["fcmToken"];
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "Photo message.",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        status: "unread",
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  void setVideoMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "Video message.",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        status: "unread",
        timestamp: Timestamp.now(),
        type: 'video');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<void> lockConversation(
      User currentUser, String lockCode, String receiverId) async {
    // Contact lockConv = Contact(isLocked: true, lockCode: lockCode);

    // var lock = lockConv.toMap(lockConv);

    var lockData =
        await getContactsDocument(of: currentUser.uid, forContact: receiverId)
            .updateData({"isLocked": true, "lockCode": lockCode});

    return lockData;
  }

  Future<void> unlockConversation(User currentUser, String receiverId) async {
    // Contact lockConv = Contact(isLocked: true, lockCode: lockCode);

    // var lock = lockConv.toMap(lockConv);

    var lockData =
        await getContactsDocument(of: currentUser.uid, forContact: receiverId)
            .updateData({
      "isLocked": false,
    });

    return lockData;
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  Stream<QuerySnapshot> fetchMessageSeenStatus({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .where("senderId", isEqualTo: receiverId)
          .snapshots();
}
