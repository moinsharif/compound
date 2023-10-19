import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/messaging/services/messaging_services.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'chatDB.dart';
import 'constants.dart';
import 'screens/zoomImage.dart';

class ChatWidget {
  static Widget widgetFullPhoto(BuildContext context, String url) {
    return Container(
        child: PhotoView(imageProvider: CachedNetworkImageProvider(url)));
  }

  static Widget widgetChatBuildItem(
      BuildContext context,
      var listMessage,
      String id,
      int index,
      DocumentSnapshot document,
      String peerAvatar,
      String peerName) {
    if (document['idFrom'] == id) {
      return Row(
        children: <Widget>[
          document['type'] == 0
              ? chatText(document['content'], id, document.data, listMessage,
                  index, true)
              : chatImage(context, id, document.data, listMessage,
                  document['content'], index, true)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ChatDBFireStore.isLastMessageLeft(listMessage, id, index)
                    ? Material(
                        child: widgetShowImages(peerAvatar, 35),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? chatText(document['content'], id, document.data,
                        listMessage, index, false)
                    : chatImage(context, id, document.data, listMessage,
                        document['content'], index, false)
              ],
            ),

            // Time
            ChatDBFireStore.isLastMessageLeft(listMessage, id, index)
                ? Container(
                    child: Text(
                      '$peerName ${DateFormat('MMM dd kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp'])))}',
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

  static Widget widgetChatBuildListMessage(groupChatId, listMessage,
      currentUserId, peerAvatar, listScrollController, peerName) {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection(MessagingService.MessagesRef)
                  .document(groupChatId)
                  .collection(MessagingService.MessageHistoryRef)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        ChatWidget.widgetChatBuildItem(
                            context,
                            listMessage,
                            currentUserId,
                            index,
                            snapshot.data.documents[index],
                            peerAvatar,
                            peerName),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  static Widget chatText(
      String chatContent,
      String id,
      Map<String, dynamic> message,
      var listMessage,
      int index,
      bool logUserMsg) {
    locator<MessagingService>().markAsRead(message);
    return Container(
      child: Text(
        chatContent,
        style: TextStyle(color: logUserMsg ? Colors.black : Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(
          color: logUserMsg ? greyColor2 : AppTheme.instance.buttonPrimary,
          borderRadius: BorderRadius.circular(8.0)),
      margin: logUserMsg
          ? EdgeInsets.only(
              bottom: ChatDBFireStore.isLastMessageRight(listMessage, id, index)
                  ? 20.0
                  : 10.0,
              right: 10.0)
          : EdgeInsets.only(left: 10.0),
    );
  }

  static Widget chatImage(
      BuildContext context,
      String id,
      Map<String, dynamic> message,
      var listMessage,
      String chatContent,
      int index,
      bool logUserMsg) {
    locator<MessagingService>().markAsRead(message);
    return Container(
      child: FlatButton(
        child: Material(
          child: widgetShowImages(chatContent, 50),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ZoomImage(url: chatContent)));
        },
        padding: EdgeInsets.all(0),
      ),
      margin: logUserMsg
          ? EdgeInsets.only(
              bottom: ChatDBFireStore.isLastMessageRight(listMessage, id, index)
                  ? 20.0
                  : 10.0,
              right: 10.0)
          : EdgeInsets.only(left: 10.0),
    );
  }

  static Widget widgetShowImages(String imageUrl, double imageSize) {
    if (StringUtils.isNullOrEmpty(imageUrl)) {
      return Icon(
        Icons.account_circle,
        size: 55.0,
        color: AppTheme.instance.primaryDarker,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: imageSize,
      width: imageSize,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Widget widgetShowText(
      String text, dynamic textSize, dynamic textColor) {
    return Text(
      '$text',
      style: TextStyle(
          color: (textColor == '') ? Colors.white70 : textColor,
          fontSize: textSize == '' ? 14.0 : textSize),
    );
  }
}
