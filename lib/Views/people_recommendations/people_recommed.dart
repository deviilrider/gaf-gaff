import 'package:flutter/material.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/ViewModel/recommendation_viewmodel.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:gafgaff/Widgets/loader.dart';
import 'package:provider/provider.dart';

import '../followButton.dart';

// Note Recommended People will only be visible if there are contacts
// that are using Writero app !!

class PeopleRecommend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecommendationsViewModel>(
        create: (_) => RecommendationsViewModel(),
        child: Consumer<RecommendationsViewModel>(
          builder: (context, model, child) {
            return FutureBuilder(
                future: Future.wait(
                    [model.init(), model.getContacts(), model.fetchUser()]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      ALertDialogs()
                        ..getErrorDialog(context, 'No friend in list');

                      return Container();
                    } else {
                      return Visibility(
                        visible: snapshot.data[1]
                        // &&
                        //     (model.filteredUsers.length > 0),
                        //Test
                        // visible: true,
                        ,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "All Contacts",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: model.filteredUsers.length,
                                      //Test
                                      // itemCount: model.usersList.length,
                                      itemBuilder: (context, index) {
                                        GafGaffUser currentUser =
                                            model.filteredUsers[index];
                                        //Test
                                        // User currentUser =
                                        //     model.usersList[index];
                                        if (model.filteredUsers.length > 0) {
                                          return _buildPerson(context,
                                              name: currentUser.displayName,
                                              image: currentUser.photoUrl,
                                              followingUserId: currentUser.uid,
                                              currentUserId: model
                                                  .currentUser.uid, onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ProfileView(
                                            //               mode: ProfileMode
                                            //                   .friend,
                                            //               ownerUID:
                                            //                   currentUser.uid,
                                            //             )));
                                          });
                                        } else {
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.error),
                                                Text(
                                                    'No any friend found in you contact.'),
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return loader();
                  }
                });
          },
        ));
  }

  _buildPerson(BuildContext context,
      {String name,
      String image,
      Function onTap,
      String currentUserId,
      bool isFollowing,
      String followingUserId}) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.2,
        // height: MediaQuery.of(context).size.height / 3,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start/
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: onTap ?? () {},
                    child: Container(
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: (image != null)
                                  ? NetworkImage(image)
                                  : AssetImage('images/no_image.jpg'),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ],
            )),
            Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  letterSpacing: 1.0,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: FollowUnfollowButton(
                  currentUserId: currentUserId,
                  ownerUID: followingUserId,
                  followingUserId: followingUserId),
            )
          ],
        ),
      ),
    );
  }
}
