import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/services/user_pref_service.dart';

import '../page/alert_notification_list.dart';
import '../page/notification_page.dart';
import 'notification_service.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    ///Get Firebase Cloud Messaging Token
    final fcmToken = await _firebaseMessaging.getToken();
    print(fcmToken);
    /// Save the FCM token to user preferences
    await UserPrefService().saveFireBaseData(
        fcmToken.toString()
    );

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

    if (type == 'notification') {
      Get.to(() => NotificationPage(tabIndex: 0));
    } else if (type == 'alert') {
      Get.to(() => NotificationPage(tabIndex: 1));
    } else {
      Get.to(() => NotificationPage());
    }
  }
}

