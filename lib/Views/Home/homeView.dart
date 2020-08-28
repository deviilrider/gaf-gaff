import 'package:flutter/material.dart';
import 'package:gafgaff/Views/Home/chatList.dart';
import '../../Widgets/appbar.dart';

class HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CostumAppBar(
              pagetitle: "Gaf-Gaff",
              actions: [
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
                        Icons.photo_camera,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
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
                        Icons.edit,
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
            Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  print('tapped');
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid, width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Color.fromRGBO(159, 159, 159, 1),
                        ),
                        hintText: "Search....",
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(159, 159, 159, 1),
                        )),
                  ),
                ),
              ),
            ),
            ChatListView()
          ],
        ),
      ),
    ));
  }
}
