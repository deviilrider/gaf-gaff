import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/constants.dart';

class FriendListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ChatView()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color.fromRGBO(51, 51, 51, 1),
                        ),
                        child: ClipOval(
                          child: Image.network(sampleImageUrl),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              "Maaz Aftab",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            "From contacts",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        },
        itemCount: 10,
      ),
    );
  }
}
