import 'package:flutter/material.dart';
import '../Home/home.dart';

class UpdateInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/gaf-gaff.png"),
                height: 80,
                width: 80,
              ),
              formWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  formWidget(BuildContext context) {
    return Form(
        child: Column(
      children: [
        Text('Enter code that you full name and upload profile picture.'),
        TextFormField(
            decoration: InputDecoration(
                hintText: 'Enter Full Name',
                prefixIcon: Icon(
                  Icons.person,
                ))),
        RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeView()));
          },
          child: Text('Upload Info'),
        )
      ],
    ));
  }
}
