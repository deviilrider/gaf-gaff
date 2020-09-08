import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/widgets/user_search.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/enum/user_state.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_methods.dart';

class ContactMethods {
  static final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

//for fetching contacts

  // List<String> deviceContactEmails = [];
  // List<User> filteredUsers = [];

  // Future<bool> getContacts() async {
  //   final PermissionStatus permissionStatus = await _getPermission();
  //   if (permissionStatus == PermissionStatus.granted) {
  //     //We can now access our contacts here
  //     List<Contact> contacts = (await ContactsService.getContacts()).toList();
  //     // List<String> emails = [];
  //     // List<String> phones = [];

  //     if (contacts == null || contacts.length == 0) {
  //       return false;
  //     }

  //     for (int i = 0; i < contacts.length; i++) {
  //       List<Item> items = contacts[i].emails.toList();
  //       for (int j = 0; j < items.length; j++) {
  //         deviceContactEmails.add(items[j].value);
  //       }
  //     }

  //     // Waits to get users from the database

  //     // for (int i = 0; i < contacts.length; i++) {
  //     //   List<Item> items = contacts[i].phones.toList();
  //     //   for (int j = 0; j < items.length; j++) {
  //     //     phones.add(items[j].value);
  //     //   }
  //     // }

  //     // print(emails);
  //     // print(phones);
  //     checkEmails();
  //     return true;
  //   }

  //   return false;
  // }

  // checkEmails() async {
  //   FirebaseUser currentUser = await AuthMethods().getCurrentUser();
  //   List<User> userList = await fetchAllUsers(currentUser);
  //   for (User user in userList) {
  //     if (deviceContactEmails.contains(user.email)) {
  //       filteredUsers.add(user);
  //     }
  //   }
  // }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<List<User>> fetchMyContacts(FirebaseUser currentUser) async {
    List<User> mycontactList = List<User>();
    List<String> currentContactUIDs = await fetchAddedContacts(currentUser.uid);

    for (var i = 0; i < currentContactUIDs.length; i++) {
      print(currentContactUIDs[i]);

      DocumentSnapshot documentSnapshot = await _firestore
          .collection("users")
          .document(currentContactUIDs[i])
          .get();
      mycontactList.add(User.fromMap(documentSnapshot.data));
    }
    return mycontactList;
  }

  //fetch added contacts
  Future<List<String>> fetchAddedContacts(String userUid) async {
    List<String> addedUIDs = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(userUid)
        .collection("added")
        .getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      addedUIDs.add(querySnapshot.documents[i].documentID);
    }

    return addedUIDs;
  }

  //search user
  searchUser(BuildContext context) async {
    AuthMethods().getCurrentUser().then((FirebaseUser user) {
      fetchAllUsers(user).then((List<User> list) {
        fetchMyContacts(user).then((List<User> contactList) {
          showSearch(
              context: context,
              delegate:
                  UserSearch(usersList: list, mycontactList: contactList));
        });
      });
    });
  }

  Future<bool> checkAdded(String ownerUID, String contactUserId) async {
    bool isFollowing = false;
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(ownerUID)
        .collection("added")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == contactUserId) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  Future<void> addUser({String currentUserId, String contactUserId}) async {
    var addedMap = Map<String, String>();
    addedMap['uid'] = contactUserId;
    await _firestore
        .collection("users")
        .document(currentUserId)
        .collection("added")
        .document(contactUserId)
        .setData(addedMap);

    var addBackMap = Map<String, String>();
    addBackMap['uid'] = currentUserId;

    return _firestore
        .collection("users")
        .document(contactUserId)
        .collection("addedBack")
        .document(currentUserId)
        .setData(addBackMap);
  }

  Future<void> removeUser({String currentUserId, String contactUserId}) async {
    await _firestore
        .collection("users")
        .document(currentUserId)
        .collection("added")
        .document(contactUserId)
        .delete();

    return _firestore
        .collection("users")
        .document(contactUserId)
        .collection("addedBack")
        .document(currentUserId)
        .delete();
  }
}
