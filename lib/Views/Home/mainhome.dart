import 'package:flutter/material.dart';
import '../../StateManagement/messageState.dart';
import '../../StateManagement/notificationState.dart';
import 'package:provider/provider.dart';
import '../../StateManagement/bodyPage.dart';
import 'homeView.dart';
import '../People/people_in_contact_list.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotificationState notificationState =
        Provider.of<NotificationState>(context, listen: false);

    final MessageState messageState =
        Provider.of<MessageState>(context, listen: false);

    final BodyPage bodyPage = Provider.of<BodyPage>(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: pageChooser(context),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: Container(
            height: 50,
            color: Colors.white,
            padding: EdgeInsets.only(left: 80, right: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      bodyPage.setPageSelect("Home");
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(Icons.message_rounded)),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      bodyPage.setPageSelect("People");
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Icon(Icons.group),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pageChooser(BuildContext context) {
    final BodyPage bodyPage = Provider.of<BodyPage>(context);
    switch (bodyPage.pageSelected) {
      case "Home":
        return HomePageView();
        break;
      case "People":
        return PeoplePageView();
        break;
      default:
        return HomePageView();
    }
  }
}
