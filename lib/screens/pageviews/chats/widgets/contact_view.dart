import 'package:flutter/material.dart';
import 'package:gafgaff/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:gafgaff/models/contact.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/resources/chat_methods.dart';
import 'package:gafgaff/screens/chatscreens/chat_screen.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/widgets/custom_tile.dart';

import 'last_message_container.dart';
import 'messageseenstatus.dart';
import 'online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return ListTile(
      leading: Container(
        constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 50,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
      title: Text(
        (contact != null ? contact.name : null) != null ? contact.name : "..",
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      trailing: MessageReadUnreadStatus(
        stream: _chatMethods.fetchMessageSeenStatus(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      onTap: () {
        ChatMethods().setMessageRead(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiver: contact,
              ),
            ));
      },
      onLongPress: () => ALertDialogs().showMessageOptions(context, contact),
    );
  }
}
