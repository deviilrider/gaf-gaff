// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:gafgaff/Models/fcm.dart';
// import 'package:gafgaff/StateManagement/messageRequestState.dart';
// import 'package:gafgaff/StateManagement/messageState.dart';
// import 'package:image/image.dart' as Im;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../connections/repo.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../Models/message.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String photoUrl;
//   final String name;
//   final String receiverUid;

//   ChatDetailScreen({this.photoUrl, this.name, this.receiverUid});

//   @override
//   _ChatDetailScreenState createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   var _formKey = GlobalKey<FormState>();
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   FirebaseFirestore _firestore;
//   ScrollController _controller = ScrollController();

//   String _senderuid;
//   TextEditingController _messageController = TextEditingController();
//   final _repository = Repository();
//   String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
//   bool pushnotifi = true;
//   StreamSubscription<DocumentSnapshot> subscription;
//   File imageFile;
//   bool isFollowed = true;
//   bool isFollowing = true;

//   @override
//   void initState() {
//     super.initState();
//     _repository.getCurrentUser().then((user) async {
//       setState(() {
//         _senderuid = user.uid; // * CURRENT USER-ID
//       });
//       // * current user detail
//       _repository.fetchUserDetailsById(_senderuid).then((user) {
//         setState(() {
//           senderPhotoUrl = user.photoUrl;
//           senderName = user.displayName;
//           pushnotifi = user.pushnotification;
//         });
//       });

//       //* receiver user detail
//       _repository.fetchUserDetailsById(widget.receiverUid).then((user) {
//         setState(() {
//           receiverPhotoUrl = user.photoUrl;
//           receiverName = user.displayName;
//         });
//       });

//       // * CHECKING IF ANY UNREAD MESSAGE TO READ MESSAGE
//       _repository.changeUnreadMessage(user, widget.receiverUid).then((value) {
//         fetchUnreadMessageTotal();
//       });

//       QuerySnapshot following = await _firestore
//           .collection("users")
//           .doc(user.uid)
//           .collection("following")
//           .where("uid", isEqualTo: widget.receiverUid)
//           .get();

//       QuerySnapshot follower = await _firestore
//           .collection("users")
//           .doc(user.uid)
//           .collection("followers")
//           .where("uid", isEqualTo: widget.receiverUid)
//           .get();

//       setState(() {
//         isFollowed = follower.docs.length > 0
//             ? true
//             : false; // * kosai le malai follow gareko
//         isFollowing = following.docs.length > 0
//             ? true
//             : false; // * maile kosai lai follow gareko
//       });
//     });

//     // * DELAYING CONTROLLER
//     Future.delayed(Duration(seconds: 2), () {
//       _controller.animateTo(_controller.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//     });

//     // Timer.periodic(Duration(seconds: 2), (timer) {
//     //   print(timer.tick);
//     //   timer.cancel();
//     // _controller.animateTo(_controller.position.maxScrollExtent,
//     //     duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//     // });
//   }

//   fetchUnreadMessageTotal() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String useruid = prefs.getString('uid');
//     final messageState = Provider.of<MessageState>(context);
//     int tmpUnSeenCount = 0;
//     int tmpSeenCount = 0;
//     QuerySnapshot _chat;
//     QuerySnapshot _messgae = await _firestore
//         .collection("users")
//         .doc(useruid)
//         .collection("message")
//         .get();

//     for (int i = 0; i < _messgae.docs.length; i++) {
//       _chat = await _firestore
//           .collection("users")
//           .doc(useruid)
//           .collection("message")
//           .doc(_messgae.docs[i].id)
//           .collection("chat")
//           .orderBy("timestamp", descending: true)
//           .get();
//     }

//     for (int i = 0; i < _chat.docs.length; i++) {
//       if (_chat.docs[i].data()["status"] == "unread") {
//         setState(() {
//           tmpUnSeenCount += 1;
//         });
//       } else {
//         setState(() {
//           tmpSeenCount += 1;
//         });
//       }
//     }
//     messageState.setTotalUnseenMessage(tmpUnSeenCount);
//     print("total unseen message: ${messageState.totalMessage}");
//     print("total seen message: $tmpSeenCount");
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     subscription?.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final messageRequest = Provider.of<MessageRequestState>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         // centerTitle: true,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               child: widget.photoUrl == null
//                   ? null
//                   : CircleAvatar(
//                       backgroundImage: NetworkImage(widget.photoUrl),
//                     ),
//             ),
//             SizedBox(
//               width: 8,
//             ),
//             Text(
//               widget.name,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//         actions: [
//           isFollowing
//               ? Container()
//               : FlatButton(
//                   onPressed: () {
//                     _repository
//                         .followUser(
//                             currentUserId: _senderuid,
//                             followingUserId: widget.receiverUid)
//                         .then((value) {
//                       setState(() {
//                         isFollowing = !isFollowing;
//                       });
//                       messageRequest.decreaseTotalMessageRequest();
//                     });
//                   },
//                   child: Text("FOLLOW",
//                       style: TextStyle(
//                         color: Colors.white,
//                       )),
//                 ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: _senderuid == null
//             ? Container(
//                 child: CircularProgressIndicator(),
//               )
//             : Column(
//                 children: <Widget>[
//                   ChatMessagesListWidget(),

//                   // * TEXTFIELD
//                   isFollowing
//                       ? chatInputWidget()
//                       : Container(
//                           child: Text("You should follow this user."),
//                         ),

//                   SizedBox(
//                     height: 15.0,
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   // * TEXTFIELD
//   Widget chatInputWidget() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade500),
//         ),
//       ),
//       height: 55.0,
//       margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//       child: TextFormField(
//         onTap: () {
//           // * CONTROLLER WITH MAXEXTENDS
//           print("hello");
//           // _controller
//           //     .animateTo(_controller.position.maxScrollExtent,
//           //         duration: Duration(milliseconds: 300), curve: Curves.easeOut)
//           //     .then((value) => print("controller executed"));
//         },
//         onChanged: (String value) {
//           print(value);
//           _controller
//               .animateTo(_controller.position.maxScrollExtent,
//                   duration: Duration(milliseconds: 300), curve: Curves.easeOut)
//               .then((value) => print("controller executed"));
//         },
//         validator: (String input) {
//           if (input.isEmpty) {
//             return "Field should not be empty";
//           }
//         },
//         controller: _messageController,
//         decoration: InputDecoration(
//           hintText: "Write Message...",
//           border: InputBorder.none,
//           suffixIcon: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               // * PICK IMAGE FROM GALLARY
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: IconButton(
//                   icon: Icon(Icons.photo),
//                   color: Colors.redAccent,
//                   onPressed: () {
//                     pickImage(source: 'Gallery');
//                   },
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.only(right: 15.0),
//                 child: InkWell(
//                   child: Icon(
//                     Icons.send,
//                     color: Colors.redAccent,
//                   ),
//                   onTap: () {
//                     if (_formKey.currentState.validate()) {
//                       print("hello");

//                       if (isFollowing) {
//                         // * IF I AM FOLLOWING HIM / HER THEN MESSAGE SENT
//                         sendMessage();
//                       } else {
//                         // * IF I AM NOT FOLLOWING HIM / HER THEN MESSAGE WILL NOT SENT
//                         SnackBar snackBar =
//                             SnackBar(content: Text("You have not follwed him"));
//                         _scaffoldKey.currentState.showSnackBar(snackBar);
//                       }

//                       // sendMessage();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),

//           // * PICK IMAGE FROM CAMERA
//           prefixIcon: IconButton(
//             icon: Icon(
//               Icons.camera_alt,
//               color: Colors.redAccent,
//             ),
//             onPressed: () {
//               pickImage(source: 'Camera');
//             },
//             color: Colors.black,
//           ),
//           // border: OutlineInputBorder(
//           //   // borderRadius: BorderRadius.circular(40.0),
//           //   borderSide: BorderSide(
//           //     color: Colors.grey.shade700,
//           //     // style: BorderS
//           //   ),
//           // ),
//         ),
//         onFieldSubmitted: (value) {
//           _messageController.text = value;
//         },
//       ),
//     );
//   }

//   Future<void> pickImage({String source}) async {
//     var selectedImage = await ImagePicker.pickImage(
//         source: source == 'Gallery' ? ImageSource.gallery : ImageSource.camera);

//     setState(() {
//       imageFile = selectedImage;
//     });
//     compressImage();
//     _repository.uploadImageToStorage(imageFile).then((url) {
//       print("URL: $url");
//       _repository.uploadImageMsgToDb(url, widget.receiverUid, _senderuid);
//     });
//     return;
//   }

//   void compressImage() async {
//     print('starting compression');
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     int rand = Random().nextInt(10000);

//     Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
//     Im.copyResize(image, width: 500, height: 500);

//     var newim2 = new File('$path/img_$rand.jpg')
//       ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

//     setState(() {
//       imageFile = newim2;
//     });
//     print('done');
//   }

//   // * SEND MESSAGE (TEXT)
//   void sendMessage() {
//     print("Inside send message");
//     var text = _messageController.text;
//     print(text);

//     // * SENDING SENDER USER A READ-STATUS
//     Message _message = Message(
//       // * SENDER MESSAGE
//       receiverUid: widget.receiverUid,
//       senderUid: _senderuid, // * CURRENT USER
//       message: text, // * USER MESSAGE
//       timestamp: FieldValue.serverTimestamp(),
//       type: 'text',
//       status: "read",
//     );

//     // * SENDING RECEIVER USER A UNREAD-STATUS
//     Message _receivermessage = Message(
//       // * RECEIVER MESSAGE
//       receiverUid: widget.receiverUid,
//       senderUid: _senderuid, // * CURRENT USER
//       message: text, // * USER MESSAGE
//       timestamp: FieldValue.serverTimestamp(),
//       type: 'text',
//       status: "unread",
//     );

//     print(
//         "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , message: ${text}");
//     print(
//         "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");

//     _repository
//         .addMessageToDb(
//             _message, _receivermessage, widget.receiverUid, isFollowed)
//         .then((v) {
//       // * LIST VIEW CONTROLLER WITH ANIMATED TO.
//       _controller
//           .animateTo(_controller.position.maxScrollExtent,
//               duration: Duration(milliseconds: 300), curve: Curves.easeOut)
//           .then((value) => print("controller executed"));

//       _messageController.text = "";

//       // * SEND NOTIFICATION ONLY WHEN PUSH NOTIFICATION IS ALLOWED
//       if (pushnotifi) {
//         print("push notification on");
//         // * FETCHING USER FCM-TOKEN
//         _repository.fetchUserFcmToken(widget.receiverUid).then((value) {
//           print("$value");
//           // * SENDING NOTIFICATION
//           FcmNotification()
//             ..fcmSendMessage(value, "$senderName has messaged you", _message,
//                     receiverId: _senderuid,
//                     receiverName: senderName,
//                     receiverImg: senderPhotoUrl)
//                 .then((value) {
//               print("Message Notification Successfully Sent");
//             });
//         });
//       } else {
//         print("push notification off");
//       }

//       print("Message added to db");
//     });
//   }

//   Widget ChatMessagesListWidget() {
//     print("SENDERUID : $_senderuid");
//     return Flexible(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(_senderuid) // * current user (firebaseuser)
//             .collection("message")
//             .doc(widget.receiverUid)
//             .collection("chat")
//             .orderBy('timestamp', descending: false)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             //listItem = snapshot.data.documents;
//             return ListView.builder(
//               controller: _controller,
//               padding: EdgeInsets.all(10.0),
//               physics: BouncingScrollPhysics(),
//               itemBuilder: (context, index) =>
//                   chatMessageItem(snapshot.data.documents[index]),
//               itemCount: snapshot.data.documents.length,
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget chatMessageItem(DocumentSnapshot snapshot) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: Row(
//             mainAxisAlignment: snapshot.data()['senderUid'] == _senderuid
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: <Widget>[
//               snapshot.data()['senderUid'] == _senderuid
//                   ? senderLayout(snapshot)
//                   : receiverLayout(snapshot)
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Widget senderLayout(DocumentSnapshot snapshot) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         // * SENDER TEXT || IMAGE
//         snapshot.data()["timestamp"] != null
//             ? timeShow(snapshot.data()["timestamp"])
//             : Text("--:--"),
//         Padding(
//           padding: const EdgeInsets.only(left: 4.0),
//           child: snapshot.data()['type'] == 'text'
//               ? Container(
//                   constraints: new BoxConstraints(
//                       minWidth: 80,
//                       maxWidth: MediaQuery.of(context).size.width * 0.5),
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                       color: Colors.deepPurple[100],
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                       border: Border.all(color: Colors.grey)),
//                   child: Text(snapshot.data()['message'],
//                       style: TextStyle(color: Colors.black, fontSize: 16.0)),
//                 )
//               : Container(
//                   child: FadeInImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(snapshot.data()['photoUrl']),
//                     placeholder: AssetImage('assets/images/blankimage.png'),
//                     width: 200.0,
//                     height: 200.0,
//                   ),
//                 ),
//         ),

//         // *SENDER PROFILE IMAGE
//         InkWell(
//           onTap: () {},
//           child: new Container(
//             height: 30.0,
//             width: 30.0,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: senderPhotoUrl != null
//                       ? NetworkImage(senderPhotoUrl)
//                       : AssetImage('assets/images/no_image.png'),
//                   fit: BoxFit.cover),
//               borderRadius: BorderRadius.circular(80.0),
//               border: Border.all(
//                 color: Colors.white,
//                 width: 2.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget receiverLayout(DocumentSnapshot snapshot) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         // * RECEIVER PROFILE IMAGE
//         InkWell(
//           onTap: () {},
//           child: new Container(
//             height: 30.0,
//             width: 30.0,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: receiverPhotoUrl != null
//                       ? NetworkImage(receiverPhotoUrl)
//                       : AssetImage('assets/images/no_image.png'),
//                   fit: BoxFit.cover),
//               borderRadius: BorderRadius.circular(80.0),
//               border: Border.all(
//                 color: Colors.white,
//                 width: 2.5,
//               ),
//             ),
//           ),
//         ),

//         // * RECEIVER TEXT || IMAGE MESSAGE
//         Padding(
//           padding: const EdgeInsets.only(left: 1.0),
//           child: snapshot.data()['type'] == 'text'
//               ? Container(
//                   constraints: new BoxConstraints(
//                       minWidth: 80,
//                       maxWidth: MediaQuery.of(context).size.width * 0.7),
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                       border: Border.all(color: Colors.grey)),
//                   child: Text(snapshot.data()["message"],
//                       style: TextStyle(color: Colors.black, fontSize: 16.0)),
//                 )
//               : Container(
//                   child: FadeInImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(snapshot.data()['photoUrl']),
//                     placeholder: AssetImage('images/blankimage.png'),
//                     width: 200.0,
//                     height: 200.0,
//                   ),
//                 ),
//         ),

//         snapshot.data()["timestamp"] != null
//             ? timeShow(snapshot.data()["timestamp"])
//             : Text("--:--")
//       ],
//     );
//   }

//   Widget timeShow(dynamic timefromDB) {
//     var databaseTime = timefromDB.toDate();
//     var time = databaseTime.toString();
//     final dateToday = DateTime.now();
//     var dateFormate = DateFormat("dd/mm/yyyy").format(DateTime.parse(time));
//     var timeGet = DateFormat(" HH:MM a").format(DateTime.parse(time));
//     var diffTime = dateToday.difference(databaseTime);
//     var timeshow = '';

//     if (diffTime.inHours < 24) {
//       timeshow = timeGet;
//     }
//     if (diffTime.inHours >= 24) {
//       timeshow = ' $timeGet \n Yesterday';
//     }
//     if (diffTime.inHours >= 48) {
//       timeshow = ' $timeGet\n$dateFormate';
//     }

//     return Text(
//       timeshow,
//       textAlign: TextAlign.justify,
//       style: timeStyle,
//     );
//   }
// }

// TextStyle timeStyle = TextStyle(
//     fontSize: 9, color: Colors.grey.shade800, fontStyle: FontStyle.italic);
