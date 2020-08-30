import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/Connections/auth.dart';
import '../Constants/constants.dart';

class Dialogs {
  Future<void> getDialog(BuildContext context) async {
    return showDialog(
      context: context,
      child: SimpleDialog(
        // useMaterialBorderRadius: true,
        key: keyContext,
        backgroundColor: Colors.white,
        children: [
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Platform.isIOS
                      ? CupertinoActivityIndicator(
                          radius: 35,
                        )
                      : CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                  Image.asset(
                    'assets/images/gaf-gaff.png',
                    height: 30,
                    width: 30,
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Please Wait....",
                style: TextStyle(color: Colors.blueAccent),
              )
            ]),
          ),
        ],
      ),
    );
  }

  //image Popup
  Future<void> imagePopup(BuildContext context, String image) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: EdgeInsets.only(top: 25),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // FlatButton.icon(
                //   color: Colors.transparent,
                //   icon: Icon(Icons.download_sharp, color: Colors.black),
                //   label: Text(
                //     'Download',
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   onPressed: () {
                //     // Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => DownloadImage()));
                //   },
                // ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 60,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.shade500),
                ),
                // FlatButton.icon(
                //   color: Colors.transparent,
                //   icon: Icon(Icons.close, color: Colors.black),
                //   label: Text(
                //     'Close',
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
              ],
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                      image,
                    ),
                    fit: BoxFit.contain,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class ALertDialogs {
  Future<void> delteAccount(BuildContext context, String uid) async {
    return showDialog(
      context: context,
      child: SimpleDialog(
        // useMaterialBorderRadius: true,
        key: keyContext,
        backgroundColor: Colors.white,
        children: [
          Center(
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Do you want to delete your account?",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Dialogs()..getDialog(context);
                          AuthServices()..deleteAccount(uid, context);
                        },
                        child: Text('Yes')),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteConversation(
      BuildContext context, String uid, String receiverId) async {
    return showDialog(
      context: context,
      child: SimpleDialog(
        // useMaterialBorderRadius: true,
        key: keyContext,
        backgroundColor: Colors.white,
        children: [
          Center(
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Do you want to delete your account?",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Dialogs()..getDialog(context);
                          AuthServices()
                            ..deleteConversation(uid, receiverId, context);
                        },
                        child: Text('Yes')),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getSuccessDialog(BuildContext context, String text) async {
    return showDialog(
      context: context,
      child: SimpleDialog(
        // useMaterialBorderRadius: true,
        key: keyContext,
        backgroundColor: Colors.white,
        children: [
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.blueAccent),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> getErrorDialog(BuildContext context, String text) async {
    return showDialog(
      context: context,
      child: SimpleDialog(
        // useMaterialBorderRadius: true,
        key: keyContext,
        backgroundColor: Colors.white,
        children: [
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.blueAccent),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
