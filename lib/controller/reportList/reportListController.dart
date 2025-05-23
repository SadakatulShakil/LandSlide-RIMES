import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lanslide_report/services/db_service.dart';
import '../../Utills/AppColors.dart';
import '../../database_helper/database.dart';
import '../../database_helper/entities/report_entities.dart'; // Import your database classes

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
      final response = await http.get(Uri.parse('http://192.168.0.51:8000/reports/'));

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        // Extracting the 'reports' list
        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('reports')) {
          List<dynamic> reportsList = decodedResponse['reports'];

          onlineReports.value = reportsList.map((e) => LandslideReport.fromJson(e)).toList();
        } else {
          print('Unexpected response format');  // DEBUGGING
          Get.snackbar('Error', 'Unexpected response format',
              backgroundColor: AppColors().app_alert_extreme,
              colorText: AppColors().app_secondary
          );
        }
      } else {
        print('Error: ${response.statusCode}');  // DEBUGGING
        Get.snackbar('Error', 'Failed to fetch online reports',
            backgroundColor: AppColors().app_alert_extreme,
            colorText: AppColors().app_secondary
        );
      }
    } catch (e) {
      print('Error: $e');  // DEBUGGING
      Get.snackbar('Error', 'Failed to fetch online reports',
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary
      );
    }
  }

  // Mark report as synced
  Future<void> markAsSynced(int id) async {
    await appDatabase.landslideReportDao.markAsSynced(id);
    fetchOfflineReports();  // Refresh the reports list after syncing
  }
}
