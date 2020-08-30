import 'package:flutter/material.dart';
import 'package:gafgaff/Views/people_recommendations/people_recommed.dart';
import '../../Widgets/appbar.dart';
import 'friendList.dart';

class PeoplePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
      CostumAppBar(
        pagetitle: "Sathi",
        actions: [
          // GestureDetector(
          //   onTap: () {},
          //   child: Card(
          //     elevation: 6,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(50)),
          //     child: Container(
          //       padding: EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //           color: Colors.grey.withOpacity(0.5),
          //           borderRadius: BorderRadius.circular(50)),
          //       child: Icon(
          //         Icons.people,
          //         size: 22,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.person_add,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Container(
            //     alignment: Alignment.centerLeft,
            //     padding: EdgeInsets.only(left: 20),
            //     child: Text(
            //       'All Contacts',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            //     )),

            PeopleRecommend()
            // FriendListView()
          ],
        ),
      )
    ]))));
  }
}
