import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/widgets/dialogs.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();

  bool isLoginPressed = false;
  String greet = "Hello";
  greeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      setState(() {
        greet = 'Good Morning,';
      });
    }
    if (hour >= 12) {
      setState(() {
        greet = 'Good Afternoon,';
      });
    }
    if (hour >= 17) {
      setState(() {
        greet = 'Good Evening,';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    greeting();
  }

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
              formWidget(context),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFFFB8B0D)),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Scaffold(
    //   backgroundColor: UniversalVariables.blackColor,
    //   body: Stack(
    //     children: [
    //       Center(
    //         child: loginButton(),
    //       ),
    //       isLoginPressed
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : Container()
    //     ],
    //   ),
    // );
  }

  Widget formWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            '$greet \nWelcome to Gaf-Gaff Community, Please choose login method to enter the community.',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        RaisedButton(
          elevation: 10,
          color: Color(0xFFA50017),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            // ALertDialogs()..getErrorDialog(context, 'Page Under Construction');
          },
          child: Text('Login with Phone',
              style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
        Text('OR'),
        RaisedButton(
          elevation: 10,
          color: Color(0xFFFB8B0D),
          child: Text('Login with Google', style: TextStyle(fontSize: 15)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () async {
            var result = await Connectivity().checkConnectivity();
            if (result == ConnectivityResult.none) {
              _noConnectionDialog();
            } else {
              Dialogs()..getDialog(context);
              // AuthServices()..handleSignIn(context);
              performLogin();
            }
          },
        ),
      ],
    );
  }

  _noConnectionDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection!'),
          content: const Text(
              'Please, check your internet connectivity and try again.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Try Again!'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text(
          "LOGIN",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        onPressed: () => performLogin(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void performLogin() async {
    setState(() {
      isLoginPressed = true;
    });

    FirebaseUser user = await _authMethods.signIn();

    if (user != null) {
      authenticateUser(user);
    }
    setState(() {
      isLoginPressed = false;
    });
  }

  void authenticateUser(FirebaseUser user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
