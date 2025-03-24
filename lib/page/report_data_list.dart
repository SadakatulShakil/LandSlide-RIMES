import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'offline_list.dart';
import 'online_list.dart';

class ReportDataList extends StatelessWidget {
  const ReportDataList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade100,
          title: const Text("Report Data"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Color(0xFF0A3D91),//background color
              child: TabBar(

                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5AAFE5), Color(0xFF3B8DD2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storage),
                      SizedBox(width: 8),
                      Text("Offline"),
                    ],
                  )),
                  Tab(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.online_prediction),
                      SizedBox(width: 8),
                      Text("Online"),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            OfflineList(),
            OnlineList(),
          ],
        ),
      ),
    );
  }
}