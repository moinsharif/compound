import 'package:compound/core/base/base_model.dart';
import 'package:compound/modules/messaging/models/chat_user_model.dart';
import 'package:compound/modules/messaging/utils/chat_utils.dart';

class ChatRoom extends BaseModel {

  final String owner;
  final String peer;
  final DateTime timestamp;

  ChatUserModel peerChatUser;
  int pendingRead = 0;
  bool lastMessageRead;
  String lastMessage;
  String lastMessageFrom;
  String lastMessageTo;
  DateTime lastMessageTimestamp;

  ChatRoom({this.owner, 
           this.peer, 
           this.timestamp});

  ChatRoom.fromData(String owner, String peer, {DateTime timestamp})
      : owner = owner,
        peer = peer,
        timestamp = timestamp;

  Map<String, dynamic> toJson(){
    return {
      'group': [owner, peer],
      'timestamp': timestamp
    };
  }

  String get id => ChatUtils.getChatGroupId(owner, peer);

}
