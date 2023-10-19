import 'dart:convert';
import 'dart:io';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  print('Handling a background message ${message.messageId}');
  PushNotificationService.allowTaps = true;
  PushNotificationService.message = message;
}

class PushNotificationService {
  NotificationDetails platformChannelSpecifics;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  bool _initializedLocal = false;
  static bool allowTaps = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  NavigatorService _navigatorService = locator<NavigatorService>();
  NotificationAppLaunchDetails notificationAppLaunchDetails;
  AuthenticationService _authService = locator<AuthenticationService>();
  static var message;

  logout() {
    _firebaseMessaging.deleteInstanceID();
    _initialized = false;
    allowTaps = false;
  }

  Future<void> _updateToken(String token) async {
    await GenericFirestoreService.db
        .collection("users")
        .document(_authService.currentUser.id)
        .updateData({'fcmToken': token});
  }

  Future<void> initialize() async {
    if (!_initializedLocal) {
      _initializedLocal = true;
      final initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final initializationSettingsIOS = IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });

      final initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (dynamic room) async {
        if (room != null) {
          _navigatorService.navigateToPageWithReplacement(MessagingViewRoute,
              arguments: {"peer": jsonDecode(room)});
          print('notification payload: ' + room);
        }
      });
    }
    if (!_initialized) {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId',
        'channelName',
        'channelDescription',
        ticker: 'ticker',
        priority: Priority.defaultPriority,
        importance: Importance.defaultImportance,
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      _firebaseMessaging.requestNotificationPermissions();

      this._updateToken(await _firebaseMessaging.getToken());
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        this._updateToken(newToken);
      });

      _firebaseMessaging.configure(
          onBackgroundMessage:
              Platform.isIOS ? null : _firebaseMessagingBackgroundHandler,
          onLaunch: (msg) async {
            print("OnLaunch---------");
            print(msg);
            handleNewMessage(msg);
          },
          onResume: (msg) async {
            print("OnResume---------");
            print(msg);
            handleNewMessage(msg);
          },
          onMessage: (msg) async {
            print("OnMessage---------");
            print(msg);
            handleNewMessage(msg);
          });

      await _firebaseMessaging.subscribeToTopic('all');
      _initialized = true;

      if (message != null) {
        handleNewMessage(message);
        message = null;
      }
    }
  }

  void handleNewMessage(msg) {
    var body = "";
    var title = "";
    dynamic room;
    allowTaps = true;
    if (Platform.isAndroid) {
      if (msg['data'] != null) {
        room = {
          "owner": msg['data']["owner"],
          "id": msg['data']["id"],
          "nickname": msg['data']["nickname"],
          "photoUrl": msg['data']["photoUrl"]
        };

        title = msg['data']['title'];
        body = msg['data']['body'];
      } else {
        title = msg['notification']['title'];
        body = msg['notification']['body'];
      }
    } else if (Platform.isIOS) {
      if (msg['room'] != null) {
        title = msg['title'];
        body = msg['body'];
        room = {
          "owner": msg["owner"],
          "id": msg["id"],
          "nickname": msg["nickname"],
          "photoUrl": msg["photoUrl"]
        };
      } else {
        title = msg['notification']['title'];
        body = msg['notification']['body'];
      }
    }

    this.showNotification(title, body, room);
  }

  void showNotification(String title, String body, dynamic room) async {
    var navigator = this._navigatorService.navigatorKey().currentState;
    var isChatOpened = false;
    navigator.popUntil((route) {
      if (route.settings.name == "chat") {
        isChatOpened = true;
      }
      return true;
    });

    if (isChatOpened) {
      return;
    }
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: jsonEncode(room));
  }

  Future<void> subscribeTopic(String name) async {
    try {
      await _firebaseMessaging.subscribeToTopic(name);
    } catch (e) {
      print(e);
    }
  }

  Future<void> unsubscribeTopic(String name) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(name);
    } catch (e) {
      print(e);
    }
  }
}
