import 'package:cached_network_image/cached_network_image.dart';
import 'package:compound/modules/messaging/flutter_chat/screens/chat.dart';
import 'package:compound/modules/messaging/models/chat_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagingListItemView extends StatelessWidget {
  final ChatRoom chat;
  const MessagingListItemView({this.chat, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userListbuildItem(context);
  }

  Widget userListbuildItem(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
          child: InkWell(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*Container(
                margin: EdgeInsets.only(right: 15.0),
                alignment: Alignment.center,
                child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 10.0,
                  minWidth: 10.0,
                  maxHeight: 20.0,
                  maxWidth: 20.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                     shape: BoxShape.circle,
                      color: this.chat.peerChatUser.online 
                          ? Colors.greenAccent
                          : Colors.red),
                ),
             )),*/
                    this.chat.peerChatUser.photoUrl != null
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    this.chat.peerChatUser.photoUrl),
                              ),
                            ),
                          )
                        : Container(
                            width: 55.0,
                            height: 55.0,
                            child: Icon(
                              Icons.account_circle,
                              size: 55.0,
                              color: AppTheme.instance.primaryColorBlue,
                            ),
                          ),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Row(children: [
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          '${this.chat.peerChatUser.nickname}',
                                          style: TextStyle(
                                              fontFamily:
                                                  AppTheme.instance.primaryFont,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme
                                                  .instance.primaryFontColor),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            20.0, 2.0, 0.0, 5.0),
                                      ),
                                      Container(
                                        child: Text(
                                          '${this.chat.lastMessage}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppTheme.instance.primaryFont,
                                              color: AppTheme
                                                  .instance.primaryFontColor),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 0.0, 0.0),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Column(children: [
                                    Text(
                                        DateFormat('MMM dd hh:mm a')
                                            .format(this.chat.timestamp),
                                        style: TextStyle(
                                            fontFamily:
                                                AppTheme.instance.primaryFont,
                                            fontSize: 11)),
                                    this.chat.pendingRead > 0
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                right: 15.0, top: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme
                                                    .instance.buttonPrimary),
                                            child: Text(
                                              '${this.chat.pendingRead}',
                                              style: TextStyle(
                                                  fontFamily: AppTheme
                                                      .instance.primaryFont,
                                                  color: AppTheme.instance
                                                      .primaryColorBlue),
                                            ))
                                        : Container(
                                            height: 30,
                                            width: 30,
                                          ),
                                  ])),
                            ])))
                  ]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "chat"),
                        builder: (context) => Chat(
                              currentUserId: this.chat.owner,
                              peerId: this.chat.peer,
                              peerName: this.chat.peerChatUser.nickname,
                              peerAvatar: this.chat.peerChatUser.photoUrl,
                            )));
              }),
          padding: EdgeInsets.fromLTRB(10.0, 2.0, 5.0, 5.0),
        ));
  }
}
