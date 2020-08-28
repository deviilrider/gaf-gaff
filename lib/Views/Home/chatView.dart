import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Views/Profile/profileview.dart';
import 'package:gafgaff/Widgets/textfield.dart';
import 'chatMessage.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileView()));
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50)),
                  child: Image.asset(
                    "assets/images/gaf-gaff.png",
                    height: 20,
                    width: 20,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Name User',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileView()));
              })
        ],
      ),
      body: Stack(
        children: [
          chatDetails(context),
          Positioned(
            child: chatInputWidget(context),
            bottom: 0,
            right: 0,
          ),
          SizedBox(height: 5),
        ],
      ),
    ));
  }

  Widget chatDetails(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      child: SingleChildScrollView(child: ChatMessageList()),
    );
  }

  Widget chatInputWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.camera_alt),
                  Icon(Icons.photo),
                  Icon(Icons.mic_none),
                ],
              )),
          Expanded(
            flex: 10,
            child: CostumTextField(
              obscureValue: false,
              hint: 'Aa',
            ),
          ),
          Expanded(flex: 2, child: Icon(Icons.thumb_up))
        ],
      ),
    );
  }
}
