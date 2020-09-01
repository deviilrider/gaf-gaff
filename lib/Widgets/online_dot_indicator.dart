import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gafgaff/enum/user_state.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          User _user;
          if (snapshot.hasData && snapshot.data.data != null) {
            _user = User.fromMap(snapshot.data.data);
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: getColor(_user?.state),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
