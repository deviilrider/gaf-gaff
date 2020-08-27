import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Widgets/textfield.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor1,
        title: Text('Name'),
        actions: [IconButton(icon: Icon(Icons.info), onPressed: () {})],
      ),
      body: ListView(
        children: [
          chatDetails(),
          chatInputWidget(),
          SizedBox(height: 5),
        ],
      ),
    ));
  }

  chatDetails() {
    return Container(
      height: 800,
    );
  }

  chatInputWidget() {
    return Container(
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
