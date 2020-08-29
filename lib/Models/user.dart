import 'dart:convert';

GafGaffUser userFromJson(String data) => GafGaffUser.fromMap(json.decode(data));

String userToJson(GafGaffUser gafGaffUser) => json.encode(gafGaffUser.toMap());

class GafGaffUser {
  String uid;
  String email;
  String photoUrl;
  String displayName;
  String country;
  String lat;
  String long;
  String phone;
  String fcmToken;
  bool pushnotification;

  GafGaffUser(
      {this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      this.country,
      this.lat,
      this.long,
      this.phone,
      this.fcmToken,
      this.pushnotification});

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['displayName'] = this.displayName;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['phone'] = this.phone;
    data['pushnotification'] = this.pushnotification;

    return data;
  }

  GafGaffUser.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.country = mapData['country'];
    this.lat = mapData['lat'];
    this.long = mapData['long'];
    this.phone = mapData['phone'];
    this.pushnotification = mapData['pushnotification'] ?? false;
  }
}
