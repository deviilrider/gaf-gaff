// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../ViewModel/base_model/base_viewmodel.dart';
// import '../connections/repo.dart';
// import '../Models/user.dart';

// class ProfileViewModel extends BaseModel {
//   var _repository = Repository();
//   GafGaffUser user;
//   GafGaffUser currentUser;
//   Future<List<DocumentSnapshot>> posts;
//   Future<List<DocumentSnapshot>> articles;

//   // Stream get following =>
//   //     _repository.fetchStats(uid: user.uid, label: 'following').asStream();

//   // Stream get followers =>
//   //     _repository.fetchStats(uid: user.uid, label: 'followers').asStream();

//   // Stream get post => _repository.fetchStatsP(uid: user.uid).asStream();

//   // Stream get article => _repository.fetchStatsA(uid: user.uid).asStream();

//   Future<void> retrieveUserDetails() async {

//     User currentUser = await _repository.getCurrentUser();
//     GafGaffUser user1 = (await _repository.retrieveUserDetails(currentUser)) as GafGaffUser;
//     user = user1;
//     this.currentUser = user1;
//     // posts = _repository.retrieveUserPosts(user.uid);
//     // articles = _repository.retrieveUserArticles(user.uid);

//     return;
//   }

//   Future<void> retrieveUserDetailsByName(String ownerUID) async {
//     User currentUser = await _repository.getCurrentUser();
//     GafGaffUser user1 = (await _repository.retrieveUserDetails(currentUser)) as GafGaffUser;
//     this.currentUser = user1;

//     GafGaffUser user = (await _repository.fetchUserDetailsById(ownerUID)) as GafGaffUser;
//     this.user = user;

//     // posts = _repository.retrieveUserPosts(user.uid);
//     // articles = _repository.retrieveUserArticles(user.uid);

//     return;
//   }
// }
