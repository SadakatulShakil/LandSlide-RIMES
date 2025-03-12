import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/controller/navigation/navigation_controller.dart';
import 'package:lanslide_report/page/mobile.dart';
import 'package:lanslide_report/page/dashboard.dart';
import 'package:lanslide_report/page/report_form_page.dart';
import 'package:lanslide_report/services/LocalizationString.dart';
import 'package:lanslide_report/services/location_service.dart';
import 'package:lanslide_report/services/user_pref_service.dart';

import 'controller/mobile/MobileController.dart';
import 'controller/navigation/navigation_binding.dart';
import 'controller/report/report_controller.dart';
import 'database_helper/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initializeDatabase();
  // User Preferences Initialization
  await UserPrefService().init();
  // User Location initialization
  try {
    await LocationService().getLocation();
  } on Exception catch (e, stack) {
    print('🔥 Location Initialization Error: $e');
    print(stack);
  }
  Get.put(database.landslideReportDao);
  Get.put(ReportController());
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
                child: Image.asset('assets/logo/bmd_logo.png', height: 96)),
        )
            : Mobile();
      }),
      initialBinding: NavigationBinding(),
      translations: LocalizationString(),
      locale: const Locale('bn', 'BD'),
    );
  }
}