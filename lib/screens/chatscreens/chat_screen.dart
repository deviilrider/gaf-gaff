import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gafgaff/constants/colors.dart';
import 'package:gafgaff/provider/user_provider.dart';
import 'package:gafgaff/screens/Profile/publicProfileView.dart';
import 'package:gafgaff/screens/pageviews/chats/widgets/new_chat_button.dart';
import 'package:gafgaff/widgets/image_view.dart';
import 'package:gafgaff/widgets/video_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gafgaff/widgets/dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gafgaff/constants/strings.dart';
import 'package:gafgaff/enum/view_state.dart';
import 'package:gafgaff/models/message.dart';
import 'package:gafgaff/models/user.dart';
import 'package:gafgaff/provider/image_upload_provider.dart';
import 'package:gafgaff/resources/auth_methods.dart';
import 'package:gafgaff/resources/chat_methods.dart';
import 'package:gafgaff/resources/storage_methods.dart';
import 'package:gafgaff/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gafgaff/screens/chatscreens/widgets/cached_image.dart';
import 'package:gafgaff/utils/call_utilities.dart';
import 'package:gafgaff/utils/permissions.dart';
import 'package:gafgaff/utils/universal_variables.dart';
import 'package:gafgaff/utils/utilities.dart';
import 'package:gafgaff/widgets/appbar.dart';
import 'package:gafgaff/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ImageUploadProvider _imageUploadProvider;

  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();
  final AuthMethods _authMethods = AuthMethods();

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  ScrollController listScrollController = ScrollController();

  List<DocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;

  File imageFile;
  File videoFile;
  String imageUrl;
  String videoUrl;

  User sender;
  String _currentUserId;
  bool isWriting = false;
  bool showEmojiPicker = false;

  bool isScrollTop = false;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        isScrollTop = true;
      });
      print("reach the top");
      setState(() {
        print("reach the top");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        isScrollTop = false;
        print("reach the bottom");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
    listScrollController.addListener(_scrollListener);
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return PickupLayout(
      scaffold: Scaffold(
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
                                receiver: widget.receiver,
                              )));
                },
                child: CircleAvatar(
                  radius: 15,
                  child: widget.receiver.profilePhoto != null
                      ? Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image:
                                    NetworkImage(widget.receiver.profilePhoto)),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 10,
                        ),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PublicProfileView(
                                receiver: widget.receiver,
                              )));
                },
                child: Text(
                  widget.receiver.name != null ? widget.receiver.name : "",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "Roboto"),
                ),
              ),
            ],
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.phone_in_talk,
                  color: Colors.blue,
                ),
                onPressed: userProvider.getUser.userRole == "pro"
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PublicProfileView(
                                      receiver: widget.receiver,
                                    )));
                      }
                    : () {
                        ALertDialogs().getErrorDialog(context,
                            'This feature is available for pro user only. Contact Admin');
                      }),
            IconButton(
                icon: Icon(
                  Icons.videocam,
                  color: Colors.blue,
                ),
                onPressed: userProvider.getUser.userRole == "pro"
                    ? () async {
                        bool permission = await Permissions
                            .cameraAndMicrophonePermissionsGranted();

                        if (permission) {
                          CallUtils().dial(
                              from: sender,
                              to: widget.receiver,
                              context: context);
                          // callNotification();
                        } else {
                          ALertDialogs()
                              .getErrorDialog(context, 'No permission granted');
                        }
                      }
                    : () {
                        ALertDialogs().getErrorDialog(context,
                            'This feature is available for pro user only. Contact Admin');
                      }),
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
                                receiver: widget.receiver,
                              )));
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
        floatingActionButton: isScrollTop
            ? GoToDownButton(
                onTap: () {
                  setState(() {
                    listScrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceInOut);
                    isScrollTop = false;
                  });
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(MESSAGES_COLLECTION)
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .limit(_limit)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.all(10),
          reverse: true,
          controller: listScrollController,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            listMessage.addAll(snapshot.data.documents);

            // mention the arrow syntax if you get the time
            return buildItem(index, snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    Message _message = Message.fromMap(document.data);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    User user = userProvider.getUser;

    if (document.data['senderId'] == user.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          _message.type == 'text'
              // Text
              ? Container(
                  child: SelectableLinkify(
                    text: _message.message,
                    onOpen: (link) => openlinkfromMessage(link),
                    options: LinkifyOptions(humanize: false),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index, user.uid) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : _message.type == 'image'
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
                            imageUrl: _message.photoUrl,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Dialogs()..imagePopup(context, _message.photoUrl);
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom:
                              isLastMessageRight(index, user.uid) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : _message.type == 'video'
                      // video
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoViewer(
                                        videoFile: _message.photoUrl)));
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.play_circle_filled),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _message.message,
                                ),
                              ],
                            ),
                            padding:
                                EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                            width: 200.0,
                            decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.circular(8.0)),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index, user.uid)
                                    ? 20.0
                                    : 10.0,
                                right: 10.0),
                          ),
                        )
                      : Container(
                          child: Image.asset(
                            'assets/images/emojis/child/${_message.message}.gif',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index, user.uid)
                                  ? 20.0
                                  : 10.0,
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
                isLastMessageLeft(index, user.uid)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PublicProfileView(
                                        receiver: widget.receiver,
                                      )));
                        },
                        child: Material(
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
                            imageUrl: widget.receiver.profilePhoto,
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                      )
                    : Container(width: 35.0),
                _message.type == 'text'
                    ? Container(
                        child: SelectableLinkify(
                          text: _message.message,
                          onOpen: (link) => openlinkfromMessage(link),
                          options: LinkifyOptions(humanize: false),
                        ),
                        // Text(
                        //   _message.message,
                        //   style: TextStyle(color: Colors.white),
                        // ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: maincolor1,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : _message.type == 'image'
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
                                  imageUrl: _message.photoUrl,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                            imageFile: _message.photoUrl)));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : _message.type == 'video'
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VideoViewer(
                                              videoFile: _message.photoUrl)));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.play_circle_filled),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        _message.message,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      color: maincolor1,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  margin: EdgeInsets.only(left: 10.0),
                                ),
                              )
                            : Container(
                                child: Image.asset(
                                  'assets/images/emojis/child/${_message.message}.gif',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    bottom: isLastMessageRight(index, user.uid)
                                        ? 20.0
                                        : 10.0,
                                    right: 10.0),
                              ),
              ],
            ),

            // Time
            isLastMessageLeft(index, user.uid)
                ? Container(
                    child: Text(
                      Utils.getDateTime(_message.timestamp.toDate()),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
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

  bool isLastMessageLeft(int index, String uid) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data['senderId'] == uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index, String uid) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data['senderId'] != uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  openlinkfromMessage(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                          title: "Video",
                          subtitle: "Share Videos",
                          icon: Icons.video_library,
                          onTap: () {
                            getVideoGallery();
                            Navigator.pop(context);
                          }),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab,
                      ),
                      // ModalTile(
                      //   title: "Contact",
                      //   subtitle: "Share contacts",
                      //   icon: Icons.contacts,
                      // ),
                      ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location,
                      ),
                      // ModalTile(
                      //   title: "Schedule Call",
                      //   subtitle: "Arrange a call and get reminders",
                      //   icon: Icons.schedule,
                      // ),
                      // ModalTile(
                      //   title: "Create Poll",
                      //   subtitle: "Share polls",
                      //   icon: Icons.poll,
                      // )
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage(BuildContext context) {
      var text = textFieldController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        status: "unread",
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      textFieldController.text = "";

      _chatMethods.addMessageToDb(_message, context);
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => addMediaModal(context),
                  child: Icon(Icons.add_circle),
                ),
          SizedBox(
            width: 10,
          ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: getImageCamera,
                ),
          SizedBox(
            width: 10,
          ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.photo),
                  onTap: getImageGallery,
                ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.mic_none),
                ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message....",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    // fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face),
                ),
              ],
            ),
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(context),
                  ))
              : Container()
        ],
      ),
    );
  }

  Future getImageGallery() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      uploadFile();
    }
  }

  Future getVideoGallery() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getVideo(
        source: ImageSource.gallery, maxDuration: Duration(minutes: 3));
    videoFile = File(pickedFile.path);

    if (videoFile != null) {
      uploadVideo();
    }
  }

  Future getImageCamera() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        ChatMethods()
            .setImageMsg(imageUrl, widget.receiver.uid, _currentUserId);
        // onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      print('error');
    });
  }

  Future uploadVideo() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(videoFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      videoUrl = downloadUrl;
      setState(() {
        ChatMethods()
            .setVideoMsg(videoUrl, widget.receiver.uid, _currentUserId);
        // onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      print('error');
    });
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);

    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
