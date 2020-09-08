import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String gid;
  Timestamp addedOn;
  String groupName;
  String adminuid;
  String groupProfilePhoto;
  String createdBy;

  Group(
      {this.gid,
      this.addedOn,
      this.groupName,
      this.adminuid,
      this.groupProfilePhoto,
      this.createdBy});

  Map toMap(Group group) {
    var data = Map<String, dynamic>();
    data['gid'] = group.gid;
    data['addedOn'] = group.addedOn;
    data['groupName'] = group.groupName;
    data['adminuid'] = group.adminuid;
    data['groupProfilePhoto'] = group.groupProfilePhoto;
    data['createdBy'] = group.createdBy;
    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData) {
    this.gid = mapData['gid'];
    this.addedOn = mapData["addedOn"];
    this.groupName = mapData["groupName"];
    this.adminuid = mapData["adminuid"];
    this.groupProfilePhoto = mapData["groupProfilePhoto"];
    this.createdBy = mapData["createdBy"];
  }
}
