import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../database_helper/database.dart'; // Import your database classes

class ReportListController extends GetxController {
  // Observable for combined reports
  var offlineReports = <LandslideReport>[].obs;
  var onlineReports = <LandslideReport>[].obs;

  late AppDatabase appDatabase;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    appDatabase = await initializeDatabase();
    fetchOfflineReports();
    fetchOnlineReports();
  }

  // Fetch all reports (both synced and unsynced)
  Future<void> fetchOfflineReports() async {
    var unsynced = await appDatabase.landslideReportDao.getUnsyncedReports();
    var synced = await appDatabase.landslideReportDao.getSyncedReports();

    // Combine both lists
    offlineReports.value = [...unsynced, ...synced];
  }

  Future<void> fetchOnlineReports() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.76:8000/reports/'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Process the data and update the reports list
        onlineReports = data.map((e) => LandslideReport.fromJson(e)).toList().obs;
      } else {
        // Handle the error
        Get.snackbar('Error', 'Failed to fetch online reports');
      }
    } catch (e) {
      // Handle the exception
      print('Error: $e');
      Get.snackbar('Error: $e', 'Failed to fetch online reports');
    }
  }

  // Mark report as synced
  Future<void> markAsSynced(int id) async {
    await appDatabase.landslideReportDao.markAsSynced(id);
    fetchOfflineReports();  // Refresh the reports list after syncing
  }
}
