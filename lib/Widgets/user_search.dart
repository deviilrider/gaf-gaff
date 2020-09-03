import 'package:flutter/material.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/screens/chatscreens/chat_screen.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/universal_variables.dart';

import 'custom_tile.dart';

class UserSearch extends SearchDelegate<String> {
  List<User> usersList;
  UserSearch({this.usersList});

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
        ? usersList
        : usersList.where((p) => p.name.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionsList.length,
        itemBuilder: ((context, index) {
          var url = suggestionsList[index].profilePhoto != null
              ? suggestionsList[index].profilePhoto
              : "https://image.flaticon.com/icons/png/512/16/16363.png";
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            receiver: suggestionsList[index],
                          )));
            },
            leading: CachedImage(
              suggestionsList[index].profilePhoto,
              radius: 25,
              isRound: true,
            ),
            // leading: CircleAvatar(
            //   backgroundImage: NetworkImage(searchedUser.profilePhoto),
            //   backgroundColor: Colors.grey,
            // ),
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
