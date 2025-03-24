import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/report_data_list.dart';

import '../controller/reportList/reportListController.dart';

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

              return ListTile(
                title: Text(report.district),
                subtitle: Text('Cause: ${report.causeOfLandSlide}'),
                trailing: status == "Unsynced"
                    ? IconButton(
                  icon: Icon(Icons.cloud_upload),
                  onPressed: () async {
                    await reportController.markAsSynced(report.id!);
                  },
                )
                    : Icon(Icons.check_circle, color: Colors.green),
                // Add status as text in the trailing
                isThreeLine: true,
                contentPadding: EdgeInsets.all(10),
              );
            },
          );
        },
      ),
    );
  }
}
