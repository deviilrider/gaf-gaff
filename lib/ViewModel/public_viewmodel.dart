// / Currently NON relevant

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Models/user.dart';

import 'base_model/base_viewmodel.dart';

class PublicViewModel extends BaseModel {
  var _repository = Repository();

  User _firebaseUser;
  GafGaffUser currentUser;

  init() async {
    await fetchFeed();
  }

  fetchFeed() async {
    User currentUser = await _repository.getCurrentUser();
    _firebaseUser = currentUser;

    GafGaffUser user = (await _repository.fetchUserDetailsById(currentUser.uid))
        as GafGaffUser;
    this.currentUser = user;
  }

  refresh() {
    notifyListeners();
  }
}
