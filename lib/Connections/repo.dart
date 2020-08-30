import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_provider.dart';
import '../models/message.dart';
import '../models/user.dart';

class Repository {
  static Repository repo;

  factory Repository() {
    if (repo == null) {
      repo = Repository._instance();
    }

    return repo;
  }

  Repository._instance();

  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(User user, BuildContext context) =>
      _firebaseProvider.addDataToDb(user, context);

  Future<void> updateUserToken(User currentUser) =>
      _firebaseProvider.updateUserToken(currentUser);

  Future<void> updateUserfcmToken(String currentUser) =>
      _firebaseProvider.updateUserfcmToken(currentUser);

  Future<User> signIn() => _firebaseProvider.signIn();

  Future<User> signInEmail(
          String email, String password, BuildContext context) =>
      _firebaseProvider.signInEmail(email, password, context);

  Future<void> resetPassword(String email) =>
      _firebaseProvider.resetPassword(email);

  Future<bool> checkGafGaffUser(String phone) =>
      _firebaseProvider.checkGafGaffUser(phone);

  Future<void> signUpEmail(String email, String password, String displayName,
          String photoUrl, BuildContext context) =>
      _firebaseProvider.signUpEmail(
          email, password, displayName, photoUrl, context);

  Future<bool> checkUserexistance(String email) =>
      _firebaseProvider.checkUserexistance(email);

  Future<bool> authenticateUser(User user) =>
      _firebaseProvider.authenticateUser(user);

  Future<User> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) =>
      _firebaseProvider.uploadImageToStorage(imageFile);

  Future<GafGaffUser> retrieveUserDetails(User user) =>
      _firebaseProvider.retrieveUserDetails(user);

  Future<List<DocumentSnapshot>> fetchPendingNotification(
          String ownerUid, DocumentReference reference) =>
      _firebaseProvider.fetchPendingNotification(ownerUid, reference);

  // Future<List<DocumentSnapshot>> fetchFollowers(String userId) =>
  //     _firebaseProvider.fetchFollowers(userId);

  // Future<List<DocumentSnapshot>> fetchFollowing(String userId) =>
  //     _firebaseProvider.fetchFollowing(userId);

  // Future<List<DocumentSnapshot>> fetchLikeStatus(DocumentReference reference) =>
  //     _firebaseProvider.fetchLikeStatus(reference);

  Future fetchUserFcmToken(String ownerUid) =>
      _firebaseProvider.fetchUserFcmToken(ownerUid);

  Future<List<String>> fetchUsersFCMToken(
          String ownerUid, DocumentReference reference) =>
      _firebaseProvider.fetchUsersFCMToken(ownerUid, reference);

  Future<String> fetchNotificationCount(
    String userId,
  ) =>
      _firebaseProvider.fetchNotificationCount(userId);

  Future<bool> checkIfUserLikedOrNot(
          String userId, DocumentReference reference) =>
      _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

  Future<bool> checkIfUserLikedOrNotA(
          String userId, DocumentReference reference) =>
      _firebaseProvider.checkIfUserLikedOrNotA(userId, reference);

  Future<List<String>> fetchAllUserNames(User user) =>
      _firebaseProvider.fetchAllUserNames(user);

  Future<String> fetchUidBySearchedName(String name) =>
      _firebaseProvider.fetchUidBySearchedName(name);

  Future<GafGaffUser> fetchUserDetailsById(String uid) =>
      _firebaseProvider.fetchUserDetailsById(uid);

  Future<void> followUser({String currentUserId, String followingUserId}) =>
      _firebaseProvider.followUser(
          currentUserId: currentUserId, followingUserId: followingUserId);

  Future<void> unFollowUser({String currentUserId, String followingUserId}) =>
      _firebaseProvider.unFollowUser(
          currentUserId: currentUserId, followingUserId: followingUserId);

  Future<bool> checkIsFollowing(String ownerUID, String currentUserId) =>
      _firebaseProvider.checkIsFollowing(ownerUID, currentUserId);

  Future<bool> checkIsBackFollowing(String ownerUID, String currentUserId) =>
      _firebaseProvider.checkIsBackFollowing(ownerUID, currentUserId);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String name, String phone) =>
      _firebaseProvider.updateDetails(uid, name, phone);

  Future<List<String>> fetchUserNames(User user) =>
      _firebaseProvider.fetchUserNames(user);

  Future<List<GafGaffUser>> fetchAllUsers(User user) =>
      _firebaseProvider.fetchAllUsers(user);

  Future<List<GafGaffUser>> fetchMessagedUser(User user) =>
      _firebaseProvider.fetchMessagedUser(user);

  Future<List<GafGaffUser>> fetchMessageRequest(
          String userUid, BuildContext context) =>
      _firebaseProvider.fetchMessageRequest(userUid, context);

  Future<List<String>> fetchUserMessagesID(User user) =>
      _firebaseProvider.fetchUserMessagesID(user);

  void uploadImageMsgToDb(String url, String receiverUid, String senderuid) =>
      _firebaseProvider.uploadImageMsgToDb(url, receiverUid, senderuid);

  Future<void> addMessageToDb(Message sender, Message receiver,
          String receiverUid, bool isFollowed) =>
      _firebaseProvider.addMessageToDb(
          sender, receiver, receiverUid, isFollowed);

  Future deleteUsersChatHistory(GafGaffUser currentUser, String receiverUid) =>
      _firebaseProvider.deleteUsersChatHistory(currentUser, receiverUid);

  Future<void> changeUnreadMessage(User user, String receiverUid) =>
      _firebaseProvider.changeUnreadMessage(user, receiverUid);

  Future<List<String>> fetchFollowingUids(User user) =>
      _firebaseProvider.fetchFollowingUids(user);

  Future<List<String>> fetchFollowerUids(User user) =>
      _firebaseProvider.fetchFollowerUids(user);

  Future<List<String>> fetchFriendsFollowersByUids(String user) =>
      _firebaseProvider.fetchFriendsFollowersByUids(user);

  Future<List<String>> fetchFriendsFollowingByUids(String user) =>
      _firebaseProvider.fetchFriendsFollowingByUids(user);

  Future<List<String>> fetchFollowingByUids(String user) =>
      _firebaseProvider.fetchFollowingByUids(user);
  //Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);

}
