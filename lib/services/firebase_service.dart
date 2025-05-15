import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lanslide_report/services/user_pref_service.dart';


class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;



  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();

    print(fcmToken);
    await UserPrefService().saveFireBaseData(
        fcmToken.toString()
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('PUSH MESSAGE');
      print(message?.notification?.title);
      print(message?.notification?.body);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.toMap());
      var title = message.notification!.title;
      var body = message.notification!.body;
      var data = message.data;

      //await NotificationService().initNotification();
      //NotificationService().showNotification(1, title, body);
    });


  }


}