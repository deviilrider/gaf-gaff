import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gafgaff/Connections/firebase_provider.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/user.dart';

import 'base_model/base_viewmodel.dart';

class BlockedUsersViewModel extends BaseModel {
  var _repository = Repository();
  FirebaseProvider provider = FirebaseProvider();

  GafGaffUser currentUser;

  Future<List<String>> future() async {
    User user = await _repository.getCurrentUser();
    currentUser = (await _repository.retrieveUserDetails(user)) as GafGaffUser;
    return provider.getBlockedUids(user);
  }

  Stream<List<GafGaffUser>> get stream {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (QuerySnapshot event) =>
            event.docs.map((e) => userFromJson(json.encode(e.data))).toList());
  }
}
