import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  String status;
  Timestamp timestamp;
  String photoUrl;

  Message({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.status,
    this.timestamp,
  });

  //Will be only called when you wish to send an image
  // named constructor
  Message.imageMessage({
    this.senderId,
    this.receiverId,
    this.message,
    this.type,
    this.status,
    this.timestamp,
    this.photoUrl,
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['status'] = this.status;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['status'] = this.status;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  // named constructor
  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.status = map['status'];
    this.timestamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
  }
}
