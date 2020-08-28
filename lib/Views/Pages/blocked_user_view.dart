import 'package:flutter/material.dart';
import 'package:gafgaff/Models/user.dart';
import 'package:gafgaff/ViewModel/blocked_users_viewmodel.dart';
import '../BaseWidget/base_widget.dart';
import '../../Widgets/loader.dart';

class BlockedUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<BlockedUsersViewModel>(
        model: BlockedUsersViewModel(),
        builder: (context, model, c) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Blocked Users"),
            ),
            body: FutureBuilder<List<String>>(
              future: model.future(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<String> blockedUids = snapshot.data;

                  return StreamBuilder<List<GafGaffUser>>(
                    stream: model.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<GafGaffUser> users = snapshot.data;

                        List<GafGaffUser> blockedUsers = [];

                        for (int i = 0; i < users.length; i++) {
                          if (blockedUids.contains(users[i].uid)) {
                            blockedUsers.add(users[i]);
                          }
                        }

                        if (blockedUsers.length < 1) {
                          return Center(child: Text("No blocked Users !"));
                        } else {
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(10.0),
                            itemCount: blockedUsers.length,
                            itemBuilder: (context, index) {
                              GafGaffUser blockedUser = blockedUsers[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(blockedUser.photoUrl),
                                ),
                                title: Text(blockedUser.displayName),
                              );
                            },
                          );
                        }
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                } else {
                  return Center(
                    child: loader(),
                  );
                }
              },
            ),
          );
        });
  }
}
