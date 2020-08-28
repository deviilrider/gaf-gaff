import 'package:flutter/material.dart';
import '../Widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ViewModel/base_model/base_viewmodel.dart';
import '../connections/repo.dart';
// import '../state/userState.dart';
// import '../welcome/route.dart';

class LoginViewModel extends BaseModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Key get formKey => _formKey;

  bool autoValidate = false;

  validate() {
    autoValidate = true;
    notifyListeners();
  }

  final _repository = Repository();

  logIn(BuildContext context) {
    validate();
    if (_formKey.currentState.validate()) {
      changeBusy(true);
      // _repository
      //     .signInEmail(emailController.text, passwordController.text, context)
      //     .then((user) {
      //   if (user != null) {
      //     _repository.authenticateUser(user).then((value) async {
      //       SharedPreferences prefs = await SharedPreferences.getInstance();
      //       prefs.setBool('isLoggedIn', true);

      //       // userNotifier.setUserInfo(
      //       //     user.displayName,
      //       //     user.email,
      //       //     user.photoUrl,
      //       //     user.uid,
      //       //     "",
      //       //     "",
      //       //     "",
      //       //     "",
      //       //     "",
      //       //     "",
      //       //     user.phoneNumber);
      //       // routePage(context);
      //     });
      //   } else {
      //     print("Error");
      //   }
      // });
      // print(emailController.text);
    }
    changeBusy(false);
  }

  forgetPassword(BuildContext context) {
    validate();
    if (_formKey.currentState.validate()) {
      changeBusy(true);
      _repository
          .resetPassword(emailController.text)
          .then((value) => buildShowDialog(context));
    } else {
      ALertDialogs()
        ..getErrorDialog(context,
            'User email doesnot exist in the data base. Sign Up first to login!');
    }

    changeBusy(false);
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Container(
          child: Text.rich(
            TextSpan(
              text: "Forgot your",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: " password",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        content: Text(
            "We have sent you an email. Check to reset password and came back. Thank You!"),
        actions: [
          MaterialButton(
            color: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Okey", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
  }
}
