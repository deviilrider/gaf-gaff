import 'package:flutter/material.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:gafgaff/widgets/costumappbar.dart';

import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: CostumAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
