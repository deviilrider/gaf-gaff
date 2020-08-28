import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderUid;
  String receiverUid;
  String type;
  String message;
  String status;
  FieldValue timestamp;
  String photoUrl;

  Message(
      {this.senderUid,
      this.receiverUid,
      this.type,
      this.message,
      this.status,
      this.timestamp});
  Message.withoutMessage(
      {this.senderUid,
      this.receiverUid,
      this.type,
      this.timestamp,
      this.status,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['status'] = this.status;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderUid = map['senderUid'];
    _message.receiverUid = map['receiverUid'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.status = map['status'];
    _message.timestamp = map['timestamp'];
    return _message;
  }
}
