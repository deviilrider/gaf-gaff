class User {
  String uid;
  String name;
  String email;
  String username;
  String status;
  String userRole;
  int state;
  String profilePhoto;
  String fcmToken;

  User(
      {this.uid,
      this.name,
      this.email,
      this.username,
      this.status,
      this.userRole,
      this.state,
      this.profilePhoto,
      this.fcmToken});

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["userRole"] = user.userRole;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["fcmToken"] = user.fcmToken;
    return data;
  }

  // Named constructor
  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.userRole = mapData['userRole'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.fcmToken = mapData['fcmToken'];
  }
}
