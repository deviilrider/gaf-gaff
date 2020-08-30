// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../ViewModel/base_model/base_viewmodel.dart';
// import '../connections/repo.dart';
// import '../models/user.dart';

// class ProfileViewModel extends BaseModel {
//   var _repository = Repository();
//   User user;
//   User currentUser;
//   Future<List<DocumentSnapshot>> posts;
//   Future<List<DocumentSnapshot>> articles;

//   Stream get following =>
//       _repository.fetchStats(uid: user.uid, label: 'following').asStream();

//   Stream get followers =>
//       _repository.fetchStats(uid: user.uid, label: 'followers').asStream();

//   Stream get post => _repository.fetchStatsP(uid: user.uid).asStream();

//   Stream get article => _repository.fetchStatsA(uid: user.uid).asStream();

//   Future<void> retrieveUserDetails() async {
//     FirebaseUser currentUser = await _repository.getCurrentUser();
//     User user1 = await _repository.retrieveUserDetails(currentUser);
//     user = user1;
//     this.currentUser = user1;
//     posts = _repository.retrieveUserPosts(user.uid);
//     articles = _repository.retrieveUserArticles(user.uid);

//     return;
//   }

//   Future<void> retrieveUserDetailsByName(String ownerUID) async {
//     FirebaseUser currentUser = await _repository.getCurrentUser();
//     User user1 = await _repository.retrieveUserDetails(currentUser);
//     this.currentUser = user1;

//     User user = await _repository.fetchUserDetailsById(ownerUID);
//     this.user = user;

//     posts = _repository.retrieveUserPosts(user.uid);
//     articles = _repository.retrieveUserArticles(user.uid);

//     return;
//   }
// }
