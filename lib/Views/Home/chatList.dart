import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/constants.dart';
import 'package:gafgaff/Views/Home/chatView.dart';

class ChatListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatView()));
            },
            contentPadding: EdgeInsets.only(bottom: 10, right: 8),
            leading: Stack(
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Color.fromRGBO(51, 51, 51, 1),
                  ),
                  child: ClipOval(
                    child: Image.network(sampleImageUrl),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: (index % 2 == 0) ? 18 : 0,
                    width: 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Colors.green,
                        border: Border.all(color: Colors.black, width: 3)),
                  ),
                  bottom: 0,
                  right: 0,
                )
              ],
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                "Maaz Aftab",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            subtitle: Text(
              "This is message of maaz aftab",
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(123, 123, 123, 1)),
            ),
            trailing: Icon(
              Icons.check_circle,
              size: 20,
              color: (index % 2 == 0)
                  ? Color.fromRGBO(101, 107, 115, 1)
                  : Colors.transparent,
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
