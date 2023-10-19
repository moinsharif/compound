
class ChatUtils{

    static String getChatGroupId(String owner, String peer){
        var groupChatId = '';
        if (owner.hashCode <= peer.hashCode) {
            groupChatId = '$owner-$peer';
        } else {
            groupChatId = '$peer-$owner';
        }
        return groupChatId;
    }
}