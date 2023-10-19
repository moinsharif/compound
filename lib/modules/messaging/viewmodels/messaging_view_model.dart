import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/content/content_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
//import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/messaging/models/chat_model.dart';
import 'package:compound/modules/messaging/services/messaging_services.dart';
import 'package:compound/router.dart';
import 'package:compound/utils/view_utils.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';

class MessagingViewModel extends BaseViewModel {
  String id;

  static const int PageLimit = 20;
  int _currentPage = 0;

  final ContentService _contentService = locator<ContentService>();
  final MessagingService _messagingService = locator<MessagingService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  List<ChatRoom> _items = List<ChatRoom>();
  List<ChatRoom> get items => _items;

  ChatRoom _loadingStub =
      ChatRoom.fromData(ViewUtils.LoadingIndicatorTitle, "");

  StreamSubscription<dynamic> _currentQuery$;
  StreamSubscription<dynamic> _pageChange$;
  StreamSubscription<dynamic> _newMessage$;
  StreamSubscription<dynamic> _readMessage$;

  bool directChat = false;

  @override
  void dispose() {
    if (_currentQuery$ != null) _currentQuery$.cancel();

    if (_pageChange$ != null) _pageChange$.cancel();

    if (_newMessage$ != null) _newMessage$.cancel();

    if (_readMessage$ != null) _readMessage$.cancel();

    super.dispose();
  }

  void load(Map<String, dynamic> peer) {
    setBusy(true);
    this._startQuery();
  }

  void navigateToPersonPicker() {
    _navigatorService
        .navigateToPageWithReplacement(MessagingPersonPickerViewRoute);
  }

  getEmptyMessage() {
    return _authenticationService.currentRole.employee
        ? "No messages"
        : "No messages";
  }

  clearTag() {
    _items = [];
    notifyListeners();
    _contentService.latestArguments = null;
    this._startQuery();
  }

  void _startQuery() {
    if (_currentQuery$ != null) _currentQuery$.cancel();

    _currentQuery$ = _messagingService.startStream().listen((chatRooms) {
      if (chatRooms != null) {
        _items.addAll(chatRooms);
        notifyListeners();
      }
      setBusy(false);
    });

    _readMessage$ = _messagingService.readMessageStream.stream.listen((id) {
      var existingItem =
          _items.where((element) => element.id == id).toList().first;
      if (existingItem != null) {
        _messagingService.removeGlobalPendingCounter(existingItem.pendingRead);
        existingItem.pendingRead = 0;
        this.notifyListeners();
      }
    });

    _newMessage$ = _messagingService.newMessageStream.stream.listen((chatRoom) {
      if (_items == null) {
        return;
      }

      var chats = _items.where((element) => element.id == chatRoom.id).toList();
      var existingItem = chats.isEmpty ? null : chats.first;
      if (existingItem != null) {
        if (chatRoom.lastMessageTo == _authenticationService.currentUser.id &&
            !chatRoom.lastMessageRead) {
          existingItem.pendingRead++;
        }
        existingItem.lastMessage = chatRoom.lastMessage;
        existingItem.lastMessageTimestamp = chatRoom.lastMessageTimestamp;
        _items.remove(existingItem);
        _items.insert(0, existingItem);
      } else {
        if (chatRoom.lastMessageTo == _authenticationService.currentUser.id &&
            !chatRoom.lastMessageRead) {
          chatRoom.pendingRead++;
        }
        //chatRoom.pendingRead++;
        _items.insert(0, chatRoom);
      }

      this.notifyListeners();
    });
  }

  Future handleItemCreated(int index) async {
    var itemPosition = index + 1;
    var requestMoreData = itemPosition % PageLimit == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ PageLimit;

    if (requestMoreData && pageToRequest > _currentPage) {
      _currentPage = pageToRequest;
      _showLoadingIndicator();
      _messagingService.fetchPage(limit: PageLimit);

      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    _items.add(_loadingStub);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _items.remove(_loadingStub);
    notifyListeners();
  }
}
