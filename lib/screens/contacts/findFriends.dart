import 'package:flutter/material.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/utils/universal_variables.dart';

import 'people_recommed.dart';

class FindFriendPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text('Find Contacts'),
                  backgroundColor: UniversalVariables.maincolor3,
                ),
                body: SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  PeopleRecommend(),
                ])))));
  }
}
