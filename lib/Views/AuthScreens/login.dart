import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Views/AuthScreens/verifyPhone.dart';
import 'package:gafgaff/Widgets/textfield.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String error;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
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
    TextEditingController phoneNumberController = TextEditingController();
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Enter your valid phone number to join gaf-gaff community. We will send you one time password on this phone number.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: CostumTextField(
                hint: '981-2345678',
                label: 'Phone Number',
                obscureValue: false,
                keyboardType: TextInputType.number,
                prefix: Text('+977 '),
                prefixIcon: Icon(Icons.phone),
                controller: phoneNumberController,
                validator: (phoneNumber) {
                  if (phoneNumber.isEmpty || phoneNumber.toString().length > 10)
                    return '* Please enter valid Phone Number';
                  else
                    return null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyPhoneView(
                                number: phoneNumberController.text,
                              )));
                }
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: maincolor3,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
