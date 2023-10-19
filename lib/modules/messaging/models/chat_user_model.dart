import 'package:compound/core/base/base_model.dart';
import 'package:compound/utils/view_utils.dart';

class ChatUserModel extends BaseModel {

  final String id;
  final String photoUrl;
  final String nickname;
  bool online = false;
  
  ChatUserModel({this.id, this.photoUrl, this.nickname, this.online});

  static ChatUserModel builder(Map<String, dynamic> data){
    return ChatUserModel.fromData(data);
  }

  ChatUserModel.fromDataProfile(Map<String, dynamic> data)
      : id = data['id'],
        photoUrl = data['img'],
        nickname = ViewUtils.getNicknameIdentifierMap(data);

  ChatUserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        photoUrl = data['photoUrl'],
        nickname = data['nickname'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoUrl': photoUrl,
      'nickname': nickname
    };
  }


}
