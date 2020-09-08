import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'base_model/base_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

class RecommendationsViewModel extends BaseModel {
  List<User> usersList = List<User>();

  User currentUser, user, messageUser;

  List<String> deviceContactEmails = [];
  List<User> filteredUsers = [];

  Future<void> init() async {
    FirebaseUser ur = await AuthMethods().getCurrentUser();
    usersList = await AuthMethods().fetchAllUsers(ur);

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
    for (User user in usersList) {
      if (deviceContactEmails.contains(user.email)) {
        filteredUsers.add(user);
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
}
