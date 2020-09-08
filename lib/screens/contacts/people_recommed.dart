import 'package:flutter/material.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/screens/Profile/publicProfileView.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/screens/viewmodels/recommendation_viewmodel.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:gafgaff/widgets/circular_button.dart';
import 'package:gafgaff/widgets/dialogs.dart';
import 'package:gafgaff/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
                future: Future.wait([model.init(), model.getContacts()]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      print('data null');
                      ALertDialogs()
                        ..getErrorDialog(context, 'No friend in list');

                      return Container();
                    } else {
                      return Visibility(
                        visible: snapshot.data[1] &&
                            (model.filteredUsers.length > 0),
                        //Test
                        // visible: true,

                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 1, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  child: Container(
                                    child: ListTile(
                                      title: Text('Invite Friends'),
                                      leading: CircularButton(
                                        icon: Icons.share,
                                        backGroundColor:
                                            UniversalVariables.maincolor3,
                                        iconColor: Colors.white,
                                        size: 20,
                                        radius: 40,
                                      ),
                                      onTap: () {
                                        Share.share(
                                            'Check Out Gaf-Gaff App for secure chat: https://play.google.com/store/apps/details?id=com.edeal.gafgaff ');
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                  "People in your contacts",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Divider(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: model.filteredUsers.length,
                                    //Test
                                    // itemCount: model.usersList.length,
                                    itemBuilder: (context, index) {
                                      User contactListUser =
                                          model.filteredUsers[index];
                                      //Test
                                      // User currentUser =
                                      //     model.usersList[index];
                                      if (model.filteredUsers.length > 0) {
                                        return _buildPerson(
                                            context, contactListUser);
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

  _buildPerson(
    BuildContext context,
    User contactListUser,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PublicProfileView(
                    receiver: contactListUser,
                  ))),
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start/
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                CachedImage(
                  contactListUser.profilePhoto,
                  isRound: true,
                  radius: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contactListUser.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contactListUser.email,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
