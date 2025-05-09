import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/mobile.dart';
import 'package:lanslide_report/page/survey_page.dart';
import 'package:lanslide_report/services/LocalizationString.dart';
import 'package:lanslide_report/services/location_service.dart';
import 'package:lanslide_report/services/user_pref_service.dart';

import 'Utills/routes/app_pages.dart';
import 'controller/mobile/MobileController.dart';
import 'controller/navigation/navigation_binding.dart';
import 'controller/report/report_controller.dart';
import 'controller/reportList/reportListController.dart';
import 'services/db_service.dart'; // Import your DBService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services sequentially
  await UserPrefService().init();

  // Initialize DBService
  final dbService = await DBService().init();

  // User Location initialization
  try {
    await LocationService().getLocation();
  } on Exception catch (e, stack) {
    print('🔥 Location Initialization Error: $e');
    print(stack);
  }

  // Put your services in GetX dependency injection
  Get.put(ReportController());
  Get.put(dbService, permanent: true); // Add DBService with permanent flag

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MobileController mobileController = Get.put(MobileController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Report',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Obx(() {
        return mobileController.isChecking.value
            ? Scaffold(
            body: Center(
              child: Image.asset('assets/logo/bmd_logo.png', height: 96),
            ))
                :
        //Mobile();
        SurveyPage();
      }),
      getPages: AppPages.routes,
      initialBinding: NavigationBinding(),
      translations: LocalizationString(),
      locale: const Locale('bn', 'BD'),
    );
  }
}