import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'base_model/base_viewmodel.dart';
import '../connections/repo.dart';
import '../models/user.dart';
import 'package:permission_handler/permission_handler.dart';

class RecommendationsViewModel extends BaseModel {
  var _repository = Repository();

  List<GafGaffUser> usersList = List<GafGaffUser>();

  List<String> messageUserUIDs = List<String>();

  GafGaffUser currentUser, user, messageUser;

  List<String> deviceContactEmails = [];
  List<GafGaffUser> filteredUsers = [];

  Future<void> init() async {
    User ur = await _repository.getCurrentUser();
    usersList = await _repository.fetchAllUsers(ur);

    return;
  }

  Future<bool> getContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      List<Contact> contacts = (await ContactsService.getContacts()).toList();
      // List<String> emails = [];
      // List<String> phones = [];

      if (contacts == null || contacts.length == 0) {
        return false;
      }

      for (int i = 0; i < contacts.length; i++) {
        List<Item> items = contacts[i].emails.toList();
        for (int j = 0; j < items.length; j++) {
          deviceContactEmails.add(items[j].value);
        }
      }

      // Waits to get users from the database

      // for (int i = 0; i < contacts.length; i++) {
      //   List<Item> items = contacts[i].phones.toList();
      //   for (int j = 0; j < items.length; j++) {
      //     phones.add(items[j].value);
      //   }
      // }

      // print(emails);
      // print(phones);
      checkEmails();
      return true;
    }

    return false;
  }

  checkEmails() {
    for (GafGaffUser user in usersList) {
      if (deviceContactEmails.contains(user.email)) {
        filteredUsers.add(user);
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<void> fetchUser() async {
    User thisUser = await _repository.getCurrentUser();

    GafGaffUser user = await _repository.fetchUserDetailsById(thisUser.uid);
    currentUser = user;

    messageUserUIDs = await _repository.fetchUserMessagesID(thisUser);

    for (var i = 0; i < messageUserUIDs.length; i++) {
      this.user = await _repository.fetchUserDetailsById(messageUserUIDs[i]);
      usersList.add(this.user);

      for (var i = 0; i < usersList.length; i++) {
        messageUser = usersList[i];
      }
    }
    return usersList;
  }
}
