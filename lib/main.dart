import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/mobile.dart';
import 'package:lanslide_report/services/LocalizationString.dart';
import 'package:lanslide_report/services/firebase_service.dart';
import 'package:lanslide_report/services/location_service.dart';
import 'package:lanslide_report/services/notification_service.dart';
import 'package:lanslide_report/services/user_pref_service.dart';

import 'Utills/firebase_option.dart';
import 'Utills/routes/app_pages.dart';
import 'Utills/widgets/location_gate.dart';
import 'controller/mobile/MobileController.dart';
import 'controller/navigation/navigation_binding.dart';
import 'services/db_service.dart'; // Import your DBService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPreferences
  await UserPrefService().init();

  // Initialize DBService
  final dbService = await DBService().init();

  try {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on Exception catch (e, stack) {
    print('🔥 Location Initialization Error: $e');
    print(stack);
  }
  await NotificationService().init();

  Get.put(dbService, permanent: true); // Add DBService with permanent flag

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MobileController mobileController = Get.put(MobileController());
  final FirebaseService _firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    _firebaseService.initNotifications();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Report',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LocationGatePage(),
      getPages: AppPages.routes,
      initialBinding: NavigationBinding(),
      translations: LocalizationString(),
      locale: const Locale('bn', 'BD'),
    );
  }
}