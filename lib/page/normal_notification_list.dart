import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/reportList/reportListController.dart';
import '../database_helper/database.dart';
import '../database_helper/entities/report_entities.dart';

class NormalNotificationList extends StatelessWidget {
  const NormalNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    return Scaffold(
      body: Center(
        child: Text('This is the general page.',
            style: TextStyle(color: Colors.blue, fontSize: 20)),
      ),
    );
  }

}