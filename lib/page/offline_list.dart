import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/reportList/reportListController.dart';
import '../database_helper/database.dart';

class OfflineList extends StatelessWidget {
  const OfflineList({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    final ReportListController reportController = Get.put(ReportListController());

    return Scaffold(
      body: Obx(
            () {
          // Observe changes in the reports list
          if (reportController.offlineReports.isEmpty) {
            return Center(child: Text("No reports found"));
          }

          return ListView.builder(
            itemCount: reportController.offlineReports.length,
            itemBuilder: (context, index) {
              final report = reportController.offlineReports[index];
              final status = report.isSynced ? "Synced" : "Unsynced"; // Determine the status

              return GestureDetector(
                onTap: () => _showReportDetails(context, report),
                child: Card(
                  elevation: 0,
                    color: Colors.blueGrey[50],
                    child: ListTile(
                    title: Text(report.district),
                    subtitle: Text('Cause: ${report.causeOfLandSlide}'),
                    trailing: status == "Unsynced"
                        ? IconButton(
                          icon: Icon(Icons.cloud_upload),
                          onPressed: () async {
                        //await reportController.markAsSynced(report.id!);
                      },
                    )
                        : Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReportDetails(BuildContext context, LandslideReport report) {
    Get.dialog(
      AlertDialog(
        title: Text("Report Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("District", report.district),
              _detailRow("Upazila", report.upazila),
              _detailRow("Latitude", report.latitude),
              _detailRow("Longitude", report.longitude),
              _detailRow("Cause", report.causeOfLandSlide),
              _detailRow("State", report.stateOfLandSlide),
              _detailRow("Water Table Level", report.waterTableLevel),
              _detailRow("Injured", report.injured),
              _detailRow("Displaced", report.displaced),
              _detailRow("Deaths", report.deaths),
              _detailRow("Land Cover Type", report.landCoverType),
              _detailRow("Slope Angle", report.slopeAngle),
              _detailRow("Rainfall Data", report.rainfallData),
              const SizedBox(height: 10),
              if (report.imagePaths != null && report.imagePaths!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Images:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      children: report.getImagePaths().map((imagePath) {
                        return Image.network(imagePath, width: 100, height: 100, fit: BoxFit.cover);
                      }).toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, softWrap: true)),
        ],
      ),
    );
  }

}
