import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'custom_action_notification.dart';
import 'custom_local_notification.dart';

class CustomFirebaseMessaging {
  final CustomLocalNotification _customLocalNotification;

  CustomFirebaseMessaging._internal(this._customLocalNotification);
  static final CustomFirebaseMessaging _singleton =
      CustomFirebaseMessaging._internal(CustomLocalNotification());
  factory CustomFirebaseMessaging() => _singleton;

  Future<void> inicialize({VoidCallback? callback}) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(badge: true, sound: true);

    getTokenFirebase();

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      //if (message.data['forceFatchRC'] != null) return callback?.call();
      if (notification != null && android != null) {
        _customLocalNotification.androidNotification(notification, android,
            payload: message.data['ownerId']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      //CustomActionNotification.actionNotification(message.data);
      // if (message.data['goTO'] != null) {
      //   //navigatorKey.currentState?.pushNamed(message.data['goTO']);
      // }
      // if (message.data['forceFatchRC'] != null) callback?.call();
    });
  }

  getTokenFirebase() async =>
      debugPrint(await FirebaseMessaging.instance.getToken());

  Future<String?> getTokenFirebaseReturn() async =>
      await FirebaseMessaging.instance.getToken();

}
