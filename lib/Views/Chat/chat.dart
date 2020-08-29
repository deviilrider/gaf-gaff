import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gafgaff/Connections/repo.dart';
import 'package:gafgaff/Constants/colors.dart';
import 'package:gafgaff/Models/fcm.dart';
import 'package:gafgaff/StateManagement/messageState.dart';
import 'package:gafgaff/Views/Profile/publicProfileView.dart';
import 'package:gafgaff/Widgets/dialogs.dart';
import 'package:gafgaff/Widgets/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatExtendedView extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  ChatExtendedView(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PublicProfileView(
                              peerId: peerId,
                              peerName: peerName,
                              peerAvatar: peerAvatar,
                            )));
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50)),
                  child: peerAvatar != null
                      ? Image.network(
                          peerAvatar,
                          height: 20,
                          width: 20,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          "assets/images/gaf-gaff.png",
                          height: 20,
                          width: 20,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              peerName != null ? peerName : "",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PublicProfileView(
                              peerId: peerId,
                              peerName: peerName,
                              peerAvatar: peerAvatar,
                            )));
              })
        ],
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  final _repository = Repository();
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName, _senderuid;
  bool pushnotifi = true;
  FirebaseFirestore _firestore;

  bool isFollowed = true;
  bool isFollowing = true;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  void fectchUserDetails() {
    _repository.getCurrentUser().then((user) async {
      setState(() {
        _senderuid = user.uid; // * CURRENT USER-ID
      });
      // * current user detail
      _repository.fetchUserDetailsById(_senderuid).then((user) {
        setState(() {
          senderPhotoUrl = user.photoUrl;
          senderName = user.displayName;
          pushnotifi = user.pushnotification;
        });
      });

      //* receiver user detail
      _repository.fetchUserDetailsById(widget.peerId).then((user) {
        setState(() {
          receiverPhotoUrl = user.photoUrl;
          receiverName = user.displayName;
        });
      });

      // * CHECKING IF ANY UNREAD MESSAGE TO READ MESSAGE
      _repository.changeUnreadMessage(user, widget.peerId).then((value) {
        // fetchUnreadMessageTotal();
      });

      QuerySnapshot following = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("requested")
          .where("uid", isEqualTo: widget.peerId)
          .get();

      QuerySnapshot follower = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("incomeRequest")
          .where("uid", isEqualTo: widget.peerId)
          .get();

      setState(() {
        isFollowed = follower.docs.length > 0
            ? true
            : false; // * kosai le malai follow gareko
        isFollowing = following.docs.length > 0
            ? true
            : false; // * maile kosai lai follow gareko
      });
    });
  }

  // fetchUnreadMessageTotal() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String useruid = prefs.getString('uid');
  //   final messageState = Provider.of<MessageState>(context);
  //   int tmpUnSeenCount = 0;
  //   int tmpSeenCount = 0;
  //   QuerySnapshot _chat;
  //   QuerySnapshot _messgae = await _firestore
  //       .collection("users")
  //       .doc(useruid)
  //       .collection("message")
  //       .get();

  //   for (int i = 0; i < _messgae.docs.length; i++) {
  //     _chat = await _firestore
  //         .collection("message")
  //         .doc(useruid)
  //         .collection(_messgae.docs[i].id)
  //         .orderBy("timestamp", descending: true)
  //         .get();
  //   }

  //   for (int i = 0; i < _chat.docs.length; i++) {
  //     if (_chat.docs[i].data()["status"] == "unread") {
  //       setState(() {
  //         tmpUnSeenCount += 1;
  //       });
  //     } else {
  //       setState(() {
  //         tmpSeenCount += 1;
  //       });
  //     }
  //   }
  //   messageState.setTotalUnseenMessage(tmpUnSeenCount);
  //   print("total unseen message: ${messageState.totalMessage}");
  //   print("total seen message: $tmpSeenCount");
  // }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      id = prefs.getString('uid') ?? '';
    });
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("message")
          .doc(peerId)
          .set({'recId': peerId, 'sendId': id});

      var documentReference = FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("message")
          .doc(peerId)
          .collection("chat")
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance
          .collection("users")
          .doc(peerId)
          .collection("message")
          .doc(id)
          .set({'recId': id, 'sendId': peerId});

      var documentReferenceR = FirebaseFirestore.instance
          .collection("users")
          .doc(peerId)
          .collection("message")
          .doc(id)
          .collection("chat")
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
            'status': 'unread'
          },
        );
      });
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReferenceR,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
            'status': 'unread'
          },
        );
      });

      if (pushnotifi) {
        print("push notification on");
        // * FETCHING USER FCM-TOKEN
        _repository.fetchUserFcmToken(widget.peerId).then((value) {
          print("$value");
          // * SENDING NOTIFICATION
          FcmNotification()
            ..fcmSendMessage(value, "$senderName has messaged you", content,
                    receiverId: _senderuid,
                    receiverName: senderName,
                    receiverImg: senderPhotoUrl)
                .then((value) {
              print("Message Notification Successfully Sent");
            });
        });
      } else {
        print("push notification off");
      }
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.data()['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: maincolor1),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document.data()['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(maincolor2),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/images/emojis/child/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document.data()['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Dialogs()
                            ..imagePopup(context, document.data()['content']);
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: Image.asset(
                        'assets/images/emojis/child/${document.data()['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(maincolor2),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document.data()['type'] == 0
                    ? Container(
                        child: Text(
                          document.data()['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: maincolor1,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document.data()['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          maincolor2),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'assets/images/emojis/child/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document.data()['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Dialogs()
                                  ..imagePopup(
                                      context, document.data()['content']);
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              'assets/images/emojis/child/${document.data()['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document.data()['timestamp']))),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'assets/images/emojis/child/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? loader() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Row(
            children: [
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: null,
                    // getImage,
                  ),
                ),
                color: Colors.white,
              ),
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                    icon: Icon(Icons.image),
                    onPressed: getImage,
                  ),
                ),
                color: Colors.white,
              ),
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                    icon: Icon(Icons.mic_none),
                    onPressed: null,
                    // getImage,
                  ),
                ),
                color: Colors.white,
              ),
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                    icon: Icon(Icons.face),
                    onPressed: getSticker,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: maincolor1, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Aa',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: id == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(maincolor2)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(id) // * current user (firebaseuser)
                  .collection("message")
                  .doc(peerId)
                  .collection("chat")
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              // .collection("users")
              // .doc(id)
              // .collection('messages')
              // .doc(peerId)
              // .collection("chat")
              // .orderBy('timestamp', descending: true)
              // .limit(_limit)
              // .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(maincolor2)));
                } else {
                  listMessage.addAll(snapshot.data.documents);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
