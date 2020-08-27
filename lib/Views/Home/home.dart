import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/list.dart';
import 'package:gafgaff/Views/Home/chatList.dart';
import '../Profile/profileview.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Gaf-Gaff",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.white,
              fontFamily: "Roboto"),
        ),
        leading: Container(
          padding: EdgeInsets.only(left: 16, top: 3, bottom: 3),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileView()));
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/gaf-gaff.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          // CircleAvatar(
          //   backgroundColor: Color.fromRGBO(51, 51, 51, 1),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.photo_camera,
          //       size: 22,
          //       color: Color.fromRGBO(195, 195, 195, 1),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 20,
          // ),
          CircleAvatar(
            backgroundColor: Color.fromRGBO(51, 51, 51, 1),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                size: 22,
                color: Color.fromRGBO(195, 195, 195, 1),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    )),
              ),
            ),
          ),
          ChatListView()
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.black,
        padding: EdgeInsets.only(left: 80, right: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/profile-pics/mmessage.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.5)),
                        color: Colors.redAccent,
                        border: Border.all(color: Colors.black, width: 3)),
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  top: 2,
                  right: 0,
                )
              ],
            ),
            Container(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/profile-pics/people.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
