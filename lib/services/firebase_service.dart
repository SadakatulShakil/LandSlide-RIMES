import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../page/alert_page.dart';
import '../page/notification_page.dart';
import 'notification_service.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      final data = message.data;

      await NotificationService().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: data['type'] ?? 'default',
      );
    });

    // App in background and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageClick(message);
    });

    // App killed (terminated) and user taps notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageClick(initialMessage);
    }
  }

  void _handleMessageClick(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? '';

    Get.to(() => NotificationPage());
    // if (type == 'notification') {
    //   Get.to(() => NotificationPage());
    // } else if (type == 'alert') {
    //   Get.to(() => AlertPage());
    // }
    // Add more types as needed
  }
}

