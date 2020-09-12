import 'package:flutter/material.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/screens/chatscreens/chat_screen.dart';
import 'package:gafgaff/screens/chatscreens/check_unlock.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/universal_variables.dart';

import 'custom_tile.dart';

class UserSearch extends SearchDelegate<String> {
  List<User> usersList;
  List<User> mycontactList;
  UserSearch({this.usersList, this.mycontactList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<User> suggestionsList = query.isEmpty
        ? mycontactList
        : usersList.where((p) => p.name.contains(query)).toList();
    return ListView.builder(
        itemCount: suggestionsList.length != null ? suggestionsList.length : 0,
        itemBuilder: ((context, index) {
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckLockMessage(
                      receiver: suggestionsList[index],
                    ),
                  ));
            },
            leading: CachedImage(
              suggestionsList[index].profilePhoto,
              radius: 25,
              isRound: true,
            ),
            title: Text(
              suggestionsList[index].username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              suggestionsList[index].name,
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
          );
        }));
  }
}
