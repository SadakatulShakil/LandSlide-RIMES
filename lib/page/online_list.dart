import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/report_data_list.dart';

import '../controller/reportList/reportListController.dart';

class OnlineList extends StatelessWidget {
  const OnlineList({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    final ReportListController reportController = Get.put(ReportListController());

    return Scaffold(
      body: Obx(
            () {
          // Observe changes in the reports list
          if (reportController.onlineReports.isEmpty) {
            return Center(child: Text("No reports found"));
          }

          return ListView.builder(
            itemCount: reportController.onlineReports.length,
            itemBuilder: (context, index) {
              final report = reportController.onlineReports[index];

              return ListTile(
                title: Text(report.district),
                subtitle: Text('Cause: ${report.causeOfLandSlide}'),
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
