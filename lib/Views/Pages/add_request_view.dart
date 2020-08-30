import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Views/Widget/add_people.dart';
import '../../models/user.dart';
import '../../connections/repo.dart';
// import '../../ui/insta_friend_profile_screen.dart';

class AddRequests extends StatefulWidget {
  final String uid;

  const AddRequests({Key key, this.uid}) : super(key: key);

  @override
  _AddRequestsState createState() => _AddRequestsState();
}

class _AddRequestsState extends State<AddRequests> {
  var _repository = Repository();
  FirebaseFirestore _firestore;
  GafGaffUser currentUser, user, followingUser, followerUser;
  IconData icon;
  Color color;
  List<DocumentSnapshot> usersList = List<DocumentSnapshot>();
  Future<List<DocumentSnapshot>> _future;
  List<String> followingUIDs,
      followersUIDs,
      currentUserFollowers = List<String>();

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    User currentUser = await _repository.getCurrentUser();

    GafGaffUser user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    fetchFollowes();
  }

  void fetchFollowes() async {
    followersUIDs = await _repository.fetchFriendsFollowersByUids(widget.uid);

    currentUserFollowers =
        await _repository.fetchFollowingByUids(this.currentUser.uid);
    usersList.clear();
    for (var i = 0; i < followersUIDs.length; i++) {
      // _future = _repository.retrievePostByUID(followersUIDs[i]);
      print(followersUIDs[i]);
      print(currentUserFollowers.length);

      DocumentSnapshot documentSnapshot =
          await _firestore.collection("users").doc(followersUIDs[i]).get();

      setState(() {
        usersList.add(documentSnapshot);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              usersList.length > 0
                  ? buildAddRequests()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.error),
                          Text('No add requests.'),
                        ],
                      ),
                    ),
            ]),
          )),
    );
  }

  ListView buildAddRequests() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: usersList.length,
      itemBuilder: ((context, index) {
        return ListTile(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ProfileView(
              //             mode: ProfileMode.friend,
              //             ownerUID: usersList[index].data["uid"],
              //             currentUser: this.currentUser)));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            title: Text(
              usersList[index].data()["displayName"],
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(usersList[index].data()["photoUrl"]),
              radius: 30.0,
            ),
            trailing: usersList[index].data()["uid"] == this.currentUser.uid

                // * IF THIS USER-UID MATCHED WITH CURRENTUSER-UID THEN
                ? SizedBox()

                // *
                : AddPeopleTile(
                    currentUserId: this.currentUser.uid,
                    followingUserId: usersList[index].data()["uid"]));
      }),
    );
  }
}
