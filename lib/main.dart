import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/dashboard.dart';
import 'package:lanslide_report/page/report_form_page.dart';
import 'package:lanslide_report/services/location_service.dart';
import 'package:lanslide_report/services/user_pref_service.dart';

import 'controller/report/report_controller.dart';
import 'database_helper/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initializeDatabase();
  // User Preferences Initialization
  await UserPrefService().init();
  // User Location initialization
  await LocationService().getLocation();
  Get.put(database.landslideReportDao);
  Get.put(ReportController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Report',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardPage(),
    );
  }
}