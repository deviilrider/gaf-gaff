import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/list.dart';

class StoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            width: 65,
            margin: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      padding: EdgeInsets.all((index % 2 == 1) ? 2 : 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color.fromRGBO(51, 51, 51, 1),
                          border: (index % 2 == 0)
                              ? Border.all(width: 0)
                              : Border.all(
                                  color: Color.fromRGBO(0, 132, 255, 1),
                                  width: 3)),
                      child: ClipOval(
                        child: (index == 0)
                            ? IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Color.fromRGBO(195, 195, 195, 1),
                                ))
                            : Image.asset(
                                "assets/profile-pics/${profilePics[index]}"),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: (index != 0) ? 18 : 0,
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
                Text(
                  "Your Story",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: (index % 2 == 1)
                          ? Colors.white
                          : Color.fromRGBO(123, 123, 123, 1)),
                )
              ],
            ),
          );
        },
        itemCount: 8,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
