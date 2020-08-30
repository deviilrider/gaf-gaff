import 'package:flutter/material.dart';
import 'package:gafgaff/Views/Chat/chat.dart';
import 'package:gafgaff/models/user.dart';

class UserSearch extends SearchDelegate<String> {
  List<GafGaffUser> usersList;
  UserSearch({this.usersList, List<GafGaffUser> userList});

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
    final List<GafGaffUser> suggestionsList = query.isEmpty
        ? usersList
        : usersList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionsList.length,
        itemBuilder: ((context, index) {
          var url = suggestionsList[index].photoUrl != null
              ? suggestionsList[index].photoUrl
              : "https://image.flaticon.com/icons/png/512/16/16363.png";
          return ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ChatExtendedView(
                            peerAvatar: url,
                            peerName: suggestionsList[index].displayName,
                            peerId: suggestionsList[index].uid,
                          ))));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(url),
            ),
            title: Text(suggestionsList[index].displayName),
          );
        }));
  }
}
