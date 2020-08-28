import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/user.dart';

import 'base_model/base_viewmodel.dart';

class HomeViewModel extends BaseModel {
  var _repository = Repository();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GafGaffUser _user = GafGaffUser();
  GafGaffUser currentUser;
  List<User> usersList = List<User>();

  init() async {
    User user = await _repository.getCurrentUser();
    _user.uid = user.uid;
    _user.displayName = user.displayName;
    _user.photoUrl = user.photoUrl;
    currentUser =
        (await _repository.fetchUserDetailsById(user.uid)) as GafGaffUser;

    usersList = (await _repository.fetchAllUsers(user)).cast<User>();

    return;
  }

  // Future<List<DocumentSnapshot>> _future() => _repository.retrieveUserPosts(_user.uid);

}