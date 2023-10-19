import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/messaging/flutter_chat/chatWidget.dart';
import 'package:compound/modules/messaging/services/messaging_services.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String currentUserId;
  static const String id = "chat";
  Chat(
      {Key key,
      @required this.currentUserId,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.instance.primaryLighter,
      //appBar: AppBarTitled(title: peerName, messagesVisible : false),
      body: _ChatScreen(
        currentUserId: currentUserId,
        peerId: peerId,
        peerAvatar: peerAvatar,
        peerName: peerName,
      ),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String currentUserId;
  final String peerName;

  final MessagingService messagingService =
      locator<MessagingService>(); //TODO MAVHA migrate to stacked architecture

  _ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName,
      @required this.currentUserId})
      : super(key: key);

  @override
  State createState() => _ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, peerName: peerName);
}

class _ChatScreenState extends State<_ChatScreen> {
  _ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName});

  String peerId;
  String peerAvatar;
  String id;
  String peerName;

  var listMessage;
  String groupChatId;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

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
    id = widget.currentUserId ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    /*Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chattingWith': peerId});*/

    setState(() {});
  }

  Future getImage(int index) async {
    imageFile = index == 0
        ? await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);

    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path,
        quality: 80, percentage: 90);

    StorageUploadTask uploadTask = reference.putFile(compressedFile);
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
      this.widget.messagingService.sendMessage(id, peerId, content, type);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
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
              ChatWidget.widgetChatBuildListMessage(
                  groupChatId,
                  listMessage,
                  widget.currentUserId,
                  peerAvatar,
                  listScrollController,
                  peerName),

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

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => getImage(0),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () => getImage(1),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
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
                color: Colors.black,
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
}
