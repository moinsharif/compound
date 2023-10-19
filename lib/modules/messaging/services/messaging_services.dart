import 'dart:async';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/modules/messaging/models/chat_model.dart';
import 'package:compound/modules/messaging/models/chat_user_model.dart';
import 'package:compound/modules/messaging/utils/chat_utils.dart';
import 'package:rxdart/rxdart.dart';

class MessagingService extends BaseService {
  static const String MessageHistoryRef = "messages_history";
  static const String MessagesRef = "messages";

  final AuthenticationService authenticationService =
      locator<AuthenticationService>();

  static const int PageLimit = 20;
  List<List<ChatRoom>> _allPagedResults = List<List<ChatRoom>>();

  final CollectionReference _collectionReference =
      GenericFirestoreService.db.collection(MessagesRef);
  final CollectionReference _usersReference =
      GenericFirestoreService.db.collection("users");

  DocumentSnapshot _lastDocument;
  bool _hasMoreData = true;
  bool _alreadyStarted = false;

  StreamController<List<ChatRoom>> _pageController;
  StreamController<ChatRoom> newMessageStream;
  StreamController<String> readMessageStream;
  BehaviorSubject<int> pendingReadsCounterStream;

  StreamSubscription<bool> _loginSuscription;
  StreamSubscription<QuerySnapshot> _chatSuscription;

  MessagingService() {
    _initStreams();
    _loginSuscription =
        authenticationService.loginStatusChangeStream.listen((value) {
      if (value) {
        if (!_alreadyStarted) {
          _alreadyStarted = true;
          start();
        }
      } else {
        _alreadyStarted = false;
        dispose();
      }
    });
  }

  void start() {
    _initStreams();
    startMessageStream();
    startPendingCounterStream();
  }

  void dispose() {
    //  if(_loginSuscription != null)
    //    _loginSuscription.cancel();

    if (_pageController != null && !_pageController.isClosed)
      _pageController.close();

    if (newMessageStream != null && !newMessageStream.isClosed)
      newMessageStream.close();

    if (readMessageStream != null && !readMessageStream.isClosed)
      readMessageStream.close();

    if (_chatSuscription != null) _chatSuscription.cancel();

    if (pendingReadsCounterStream != null &&
        !pendingReadsCounterStream.isClosed) pendingReadsCounterStream.close();
  }

  void _initStreams() {
    if (newMessageStream == null || newMessageStream.isClosed)
      newMessageStream = StreamController<ChatRoom>.broadcast();

    if (readMessageStream == null || readMessageStream.isClosed)
      readMessageStream = StreamController<String>.broadcast();

    if (pendingReadsCounterStream == null || pendingReadsCounterStream.isClosed)
      pendingReadsCounterStream = BehaviorSubject<int>();
  }

  void addGlobalPendingCounter(int value) {
    var lastValue = pendingReadsCounterStream.value;
    pendingReadsCounterStream.sink.add(lastValue + value);
  }

  void removeGlobalPendingCounter(int value) {
    var lastValue = pendingReadsCounterStream.value;
    var newValue = lastValue - value;
    pendingReadsCounterStream.sink.add(newValue > 0 ? newValue : 0);
  }

  void startMessageStream() {
    var fromId = authenticationService.currentUser.id;
    var query = _collectionReference
        .where("group", arrayContainsAny: [fromId])
        .orderBy('timestamp', descending: true)
        .limit(1);

    try {
      if (_chatSuscription != null) {
        _chatSuscription.cancel();
      }
    } catch (e) {}

    bool initializing = true;
    this._chatSuscription = query.snapshots().listen((snapshot) async {
      if (initializing) {
        initializing = false;
        return;
      }

      if (snapshot.documents.isNotEmpty) {
        var chatRoom = await _getChatRoom(snapshot.documents[0].data);
        if (chatRoom.lastMessage != null && chatRoom.lastMessage != "") {
          if (chatRoom.lastMessageTo == authenticationService.currentUser.id &&
              !chatRoom.lastMessageRead) {
            this.addGlobalPendingCounter(1);
          }
          newMessageStream.sink.add(chatRoom);
        }
      }
    });
  }

  void startPendingCounterStream() async {
    var counter = await this._getGlobalPendingReads();
    pendingReadsCounterStream.sink.add(counter);
  }

  markAsRead(Map<String, dynamic> message) {
    if (message["read"] != null && message["read"] == true) {
      return;
    }

    if (message["idFrom"] == authenticationService.currentUser.id) {
      return;
    }

    var groupChatId =
        ChatUtils.getChatGroupId(message["idFrom"], message["idTo"]);

    readMessageStream.sink.add(groupChatId);

    var chatRoomReference = _collectionReference.document(groupChatId);
    chatRoomReference
        .collection(MessageHistoryRef)
        .document(message["timestamp"])
        .updateData({"read": true});
  }

  sendMessage(String owner, String peer, String content, int type) async {
    var timeStamp = DateTime.now();
    var groupChatId = ChatUtils.getChatGroupId(owner, peer);
    var chatRoomReference = _collectionReference.document(groupChatId);

    var chatHistoryReference = chatRoomReference
        .collection(MessageHistoryRef)
        .document(timeStamp.millisecondsSinceEpoch.toString());

    var batch = Firestore.instance.batch();
    batch.setData(chatRoomReference, {
      'group': [owner, peer],
      'timestamp': timeStamp
    });
    batch.setData(
      chatHistoryReference,
      {
        'idFrom': owner,
        'idTo': peer,
        'timestamp': timeStamp.millisecondsSinceEpoch.toString(),
        'content': content,
        'type': type,
        'read': false
      },
    );
    batch.commit();
  }

  Stream startStream({limit}) {
    if (_pageController != null && !_pageController.isClosed)
      _pageController.close();

    _pageController = StreamController<List<ChatRoom>>.broadcast();
    _lastDocument = null;
    _allPagedResults.clear();
    _hasMoreData = true;
    fetchPage(limit: limit);
    return _pageController.stream;
  }

  void fetchPage({limit}) async {
    var fromId = authenticationService.currentUser.id;

    var query = _collectionReference
        .where("group", arrayContainsAny: [fromId])
        .orderBy('timestamp', descending: true)
        .limit(limit != null ? limit : PageLimit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;

    var snapshot = await query.getDocuments();
    List<ChatRoom> chats = [];
    if (snapshot.documents.isNotEmpty) {
      var futures = <Future<ChatRoom>>[];
      for (var i = 0; i < snapshot.documents.length; i++) {
        futures
            .add(_getChatRoom(snapshot.documents[i].data, loadUnreads: true));
      }

      var data = await Future.wait(futures);
      chats.addAll(data.where((element) => element != null));

      var pageExists = currentRequestIndex < _allPagedResults.length;
      if (pageExists) {
        _allPagedResults[currentRequestIndex] = chats;
      } else {
        _allPagedResults.add(chats);
      }

      if (_pageController.isClosed) return;

      _pageController.add(chats);
      if (currentRequestIndex == _allPagedResults.length - 1) {
        _lastDocument = snapshot.documents.last;
      }

      _hasMoreData = chats.length == PageLimit;
    } else {
      _pageController.add([]);
    }
  }

  Future<int> _getGlobalPendingReads() async {
    var unreadCount = await GenericFirestoreService.db
        .collectionGroup(MessageHistoryRef)
        .where("read", isEqualTo: false)
        .where("idTo", isEqualTo: this.authenticationService.currentUser.id)
        .limit(50)
        .getDocuments();

    return unreadCount.documents.isNotEmpty ? unreadCount.documents.length : 0;
  }

  Future<int> _getPendingReads(String groupId) async {
    var unreadCount = await _collectionReference
        .document(groupId)
        .collection(MessageHistoryRef)
        .where("read", isEqualTo: false)
        .where("idTo", isEqualTo: this.authenticationService.currentUser.id)
        .limit(20)
        .getDocuments();

    return unreadCount.documents.isNotEmpty ? unreadCount.documents.length : 0;
  }

  Future<ChatRoom> _getChatRoom(Map<String, dynamic> data,
      {loadUnreads = false}) async {
    var fromId = authenticationService.currentUser.id;
    var timestamp = data['timestamp'] != null && data['timestamp'] != ""
        ? DateTime.parse(data['timestamp'].toDate().toString())
        : null;

    var peerId = data['group'][0];
    if (data['group'][0] == fromId) {
      peerId = data['group'][1];
    }

    var chat = ChatRoom.fromData(fromId, peerId, timestamp: timestamp);
    var groupChatId = ChatUtils.getChatGroupId(chat.owner, chat.peer);

    DocumentReference profileRef = _usersReference.document(chat.peer);

    var futures = <Future<dynamic>>{
      profileRef.get(),
      _collectionReference
          .document(groupChatId)
          .collection(MessageHistoryRef)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .getDocuments()
    };

    if (loadUnreads) {
      futures.add(_getPendingReads(groupChatId));
    }

    var response = await Future.wait(futures);
    var peerDoc = response[0] as DocumentSnapshot;
    var lastMessageSnapshot = response[1] as QuerySnapshot;
    var pendingReads = loadUnreads ? response[2] as int : 0;

    if (lastMessageSnapshot.documents.isNotEmpty) {
      chat.peerChatUser = ChatUserModel.fromDataProfile(peerDoc.data);
      chat.lastMessageRead = lastMessageSnapshot.documents[0].data["read"];
      chat.lastMessageFrom = lastMessageSnapshot.documents[0].data["idFrom"];
      chat.lastMessageTo = lastMessageSnapshot.documents[0].data["idTo"];
      chat.lastMessage = lastMessageSnapshot.documents[0].data["content"];
      chat.lastMessageTimestamp = DateTime.fromMillisecondsSinceEpoch(
          int.parse(lastMessageSnapshot.documents[0].data["timestamp"]));
      chat.pendingRead = pendingReads;

      if (chat.lastMessage != null && chat.lastMessage != "") {
        return chat;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
