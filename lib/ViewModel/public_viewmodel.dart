// // / Currently NON relevant

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class PublicViewModel extends BaseModel {
//   var _repository = Repository();

//   FirebaseUser _firebaseUser;
//   User currentUser;

//   Future<List<DocumentSnapshot>> get future =>
//       _repository.fetchFeedPublic(_firebaseUser);

//   Future<List<DocumentSnapshot>> futureWithLatestContent() async {
//     List<DocumentSnapshot> posts = await future;

//     List<DocumentSnapshot> filteredList = [];
//     DateTime twoDaysAgo = DateTime.now().subtract(Duration(days: 2));

//     for (var x in posts) {
//       DateTime timestamp = x.data['time'].toDate();

//       if (timestamp.isAfter(twoDaysAgo)) {
//         filteredList.add(x);
//       }
//     }

//     return filteredList;
//   }

//   Future<List<DocumentSnapshot>> futureWithMostLikes() async {
//     List<DocumentSnapshot> posts = await future;

//     var total = 0;

//     for (var x in posts) {
//       var currentLikes = (await _repository.fetchPostLikes(x.reference)).length;
//       total += currentLikes;
//     }

//     var averageLikes = total / posts.length;

//     List<DocumentSnapshot> filteredList = [];

//     for (var x in posts) {
//       var currentLikes = (await _repository.fetchPostLikes(x.reference)).length;
//       if (currentLikes > averageLikes) {
//         filteredList.add(x);
//       }
//     }

//     return filteredList;
//   }

//   init() async {
//     await fetchFeed();
//   }

//   fetchFeed() async {
//     FirebaseUser currentUser = await _repository.getCurrentUser();
//     _firebaseUser = currentUser;

//     User user = await _repository.fetchUserDetailsById(currentUser.uid);
//     this.currentUser = user;
//   }

//   refresh() {
//     notifyListeners();
//   }
// }
