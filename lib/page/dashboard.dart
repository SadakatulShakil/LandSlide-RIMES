import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:lanslide_report/page/notification_page.dart';

import '../Utills/AppDrawer.dart';
import '../controller/dashboard/DashboardController.dart';
import '../controller/network/network_controller.dart';
import '../services/api_urls.dart';

class DashboardPage extends StatelessWidget {
  // Sample pie chart data for landslide types
  final controller = Get.put(DashboardController());
  final NetworkController internetController = Get.put(NetworkController());
  final pieChartData = [
    PieChartSectionData(
      value: 40,
      color: Colors.blue,
      title: 'Type 1',
      radius: 60, // Optional: radius of the section
    ),
    PieChartSectionData(
      value: 30,
      color: Colors.green,
      title: 'Type 2',
      radius: 60,
    ),
    PieChartSectionData(
      value: 20,
      color: Colors.red,
      title: 'Type 3',
      radius: 60,
    ),
    PieChartSectionData(
      value: 10,
      color: Colors.yellow,
      title: 'Type 4',
      radius: 60,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
          backgroundColor: Colors.teal.shade50,
          automaticallyImplyLeading: false,
          title: Obx(() => ListTile(
              title: Text(controller.fullname.value.isEmpty ? controller.mobile.value : controller.fullname.value, style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(controller.initTime.value),
          )
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, size: 28, color: AppColors().app_primary,),
                    onPressed: () {
                      Get.to(()=> NotificationPage(),transition: Transition.rightToLeft);
                      // Handle notification icon press
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 6,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal.shade100,
                  child: Builder(
                    builder: (context) => IconButton(onPressed: (){ Scaffold.of(context).openDrawer();},
                      icon: Icon(Icons.menu), iconSize: 20, color: AppColors().app_primary,),
                  )
              ),
            ),
          ]
      ),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('today_weather'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                !internetController.isNetworkWorking.value
                    ?_buildWeatherCardDemo()
                    :_buildWeatherCard(),
                SizedBox(height: 10),
                const SizedBox(height: 10),
                _buildLandslideBarChart(),
                SizedBox(height: 10),
                _buildLandslideLineChart(),
                SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Weather Card
  Widget _buildWeatherCardDemo() {
    return Card(
      color: AppColors().app_primary_bg,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_sharp, color: AppColors().app_primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dhaka, Bangladesh", style: TextStyle(color: AppColors().black_font_color)),
                                Text("Sunday, 1 June 2025", style: TextStyle(color: AppColors().black_font_color)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Image.asset('assets/weather/cloud.png', height: 48),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "28°C",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors().app_primary),
                            ),
                          ),
                          SizedBox(width: 16),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.arrow_upward, size: 14, color: AppColors().app_primary)),
                                TextSpan(text: "32°C", style: TextStyle(color: AppColors().app_primary)),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.arrow_downward, size: 14, color: AppColors().app_primary)),
                                TextSpan(text: "25°C", style: TextStyle(color: AppColors().app_primary)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: AppColors().app_primary),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Icon(CupertinoIcons.cloud_heavyrain, color: AppColors().app_primary),
                    Text("Rainfall", style: TextStyle(color: AppColors().black_font_color)),
                    Text("12 mm", style: TextStyle(color: AppColors().app_primary, fontWeight: FontWeight.w500, fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Icon(CupertinoIcons.drop, color: AppColors().app_primary),
                    Text("Humidity", style: TextStyle(color: AppColors().black_font_color)),
                    Text("78 %", style: TextStyle(color: AppColors().app_primary, fontWeight: FontWeight.w500, fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Icon(CupertinoIcons.wind, color: AppColors().app_primary),
                    Text("Wind", style: TextStyle(color: AppColors().black_font_color)),
                    Text("15 km/h", style: TextStyle(color: AppColors().app_primary, fontWeight: FontWeight.w500, fontSize: 16)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Obx(()=> Card(
      color:  AppColors().app_primary_bg, //Colors.teal.shade50,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Row(
                        children: [
                          Icon(Icons.location_on_sharp, color: AppColors().app_primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(controller.currentLocationName.value ?? "", style: TextStyle(color: AppColors().black_font_color)),
                                Text(controller.forecast.value.length > 0 ? "${controller.forecast.value[0]?['weekday']}, ${controller.forecast.value[0]?['date']}" : "", style: TextStyle(color: AppColors().black_font_color)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Image.network( controller.forecast.value.length > 0 ? ApiURL.bamis_url + "assets/weather_icons/${controller.forecast.value[0]['icon']}" : ApiURL.placeholder_auth, height: 48),
                              // Text(controller.forecast.value.length > 0 ? "${controller.forecast.value[0]['type']}" : "", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: controller.forecast.value.length > 0 ? "${controller.forecast.value[0]['temp']['val_avg']}${controller.forecast.value[0]['temp_unit']}" : "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors().app_primary)
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.arrow_upward, size: 14, color: AppColors().app_primary)),
                                    TextSpan(text: controller.forecast.value.length > 0 ? "${controller.forecast.value[0]['temp']['val_max']}${controller.forecast.value[0]['temp_unit']}" : "", style: TextStyle(color: AppColors().app_primary))
                                  ]
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.arrow_downward, size: 14, color: AppColors().app_primary)),
                                    TextSpan(text: controller.forecast.value.length > 0 ? "${controller.forecast.value[0]['temp']['val_min']}${controller.forecast.value[0]['temp_unit']}" : "", style: TextStyle(color: AppColors().app_primary))
                                  ]
                              )
                          ),
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 12),
            controller.isForecastLoading.value == true ? LinearProgressIndicator() : Divider(height: 1, thickness: 1, color: AppColors().app_primary),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Icon(
                      CupertinoIcons.cloud_heavyrain,
                      color: AppColors().app_primary,
                    ),
                    Text(
                      "dashboard_rainfall".tr,
                      style: TextStyle(color: AppColors().black_font_color),
                    ),
                    Text(controller.forecast.value.length > 0 ?
                    "${controller.forecast.value[0]['rf']['val_avg'] ?? ''} ${controller.forecast.value[0]['rf_unit'] ?? ''}" : "",
                      style: TextStyle(
                          color: AppColors().app_primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      CupertinoIcons.drop,
                      color: AppColors().app_primary,
                    ),
                    Text(
                      "dashboard_humidity".tr,
                      style: TextStyle(color: AppColors().black_font_color),
                    ),
                    Text(controller.forecast.value.length > 0 ?
                    "${controller.forecast.value[0]['rh']['val_avg'] ?? ''} ${controller.forecast.value[0]['rh_unit'] ?? ''}" : "",
                      style: TextStyle(
                          color: AppColors().app_primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      CupertinoIcons.wind,
                      color: AppColors().app_primary,
                    ),
                    Text(
                      "dashboard_wind".tr,
                      style: TextStyle(color: AppColors().black_font_color),
                    ),
                    Text(controller.forecast.value.length > 0 ?
                    "${controller.forecast.value[0]['windspd']['val_avg']} ${controller.forecast.value[0]['windspd_unit']}" : "",
                      style: TextStyle(
                          color: AppColors().app_primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    )
    );
  }

  Widget _buildLandslideBarChart() {
    return Card(
      color: AppColors().app_primary_bg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors().app_primary, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('landslide_frequency'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawHorizontalLine: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}', style: TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jan');
                            case 1:
                              return Text('Feb');
                            case 2:
                              return Text('Mar');
                            case 3:
                              return Text('Apr');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 11, width: 20, color: AppColors().app_primary),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 10, width: 20, color: AppColors().app_primary),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 15, width: 20, color: AppColors().app_primary),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 12, width: 20, color: AppColors().app_primary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandslideLineChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('landslide_frequency_overtime'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawHorizontalLine: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}', style: TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jan');
                            case 1:
                              return Text('Feb');
                            case 2:
                              return Text('Mar');
                            case 3:
                              return Text('Apr');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 11),
                        FlSpot(1, 10),
                        FlSpot(2, 15),
                        FlSpot(3, 12),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      color: AppColors().app_primary,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
