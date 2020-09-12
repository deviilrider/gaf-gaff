import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  String lockCode;
  bool isLocked;
  Timestamp addedOn;

  Contact({
    this.uid,
    this.lockCode,
    this.isLocked,
    this.addedOn,
  });

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['lockCode'] = contact.lockCode;
    data['isLocked'] = contact.isLocked;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.lockCode = mapData['lockCode'];
    this.isLocked = mapData['isLocked'];
    this.addedOn = mapData["added_on"];
  }
}
