import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:gafgaff/Widgets/textfield.dart';
import '../Home/home.dart';

class UpdateInfoView extends StatefulWidget {
  @override
  _UpdateInfoViewState createState() => _UpdateInfoViewState();
}

class _UpdateInfoViewState extends State<UpdateInfoView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Image(
                image: AssetImage("assets/images/gaf-gaff.png"),
                height: 80,
                width: 80,
              ),
              formWidget(context)
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            height: 40,
            child: Column(
              children: [
                Text(
                  'powered by',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'E. Deal Nepal',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: maincolor3),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  formWidget(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Enter code that you full name and upload profile picture.'),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                // onTap: selectImage,
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey,
                  border: Border.all(
                      width: 4,
                      color: Colors.indigo,
                      style: BorderStyle.solid)),

              height: 130,
              width: 130,
              child:
                  //  uploadImage.imageFile == null
                  //     ?
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  Text(
                    'Add Profile Photo',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              // : Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         image: DecorationImage(
              //           image:
              //               FileImage(uploadImage.imageFile),
              //           fit: BoxFit.cover,
              //         )),
              //   )),
            )),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CostumTextField(
                hint: 'Full Name',
                label: 'Full Name',
                obscureValue: false,
                prefixIcon: Icon(Icons.person),
                controller: fullName,
                validator: (name) {
                  if (name.isEmpty)
                    return '* Please enter Full Name';
                  else
                    return null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              elevation: 10,
              color: maincolor3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Dialogs()..getDialog(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                }
              },
              child: Text('Upload Info'),
            )
          ],
        ));
  }
}
