import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/AppDrawer.dart';

class DashboardPage extends StatelessWidget {
  // Sample pie chart data for landslide types
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
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text("dashboard".tr, style: TextStyle(fontWeight: FontWeight.w700)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal.shade50,
                  child: Builder(
                    builder: (context) => IconButton(onPressed: (){ Scaffold.of(context).openDrawer(); }, icon: Icon(Icons.menu), iconSize: 20),
                  )
              ),
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherCard(),
              SizedBox(height: 10),
              _buildLandslideBarChart(),
              SizedBox(height: 10),
              _buildLandslideLineChart(),
              SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }

  // Weather Card
  Widget _buildWeatherCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        //side: const BorderSide( width: 1.0),
      ),
      //color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('Weather forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sunday',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '9th March 2025',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.sunny_snowing,
                      size: 30,
                      color: Colors.orange,
                    ),
                    Text(
                      'Sunny and Snowing',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const Divider(),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildForecastDetail(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: "25°C",
                ),
                _buildForecastDetail(
                  icon: Icons.water_drop,
                  label: 'Precipitation',
                  value: "50mm",
                ),
                _buildForecastDetail(
                  icon: Icons.opacity,
                  label: 'Humidity',
                  value: "80%",
                ),
                _buildForecastDetail(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: "10km/h",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastDetail({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.green,
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLandslideBarChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Landslide Frequency', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        BarChartRodData(fromY: 0, toY: 11, width: 20),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 10, width: 20),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 15, width: 20),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 12, width: 20),
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
            Text('Landslide Frequency Over Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      color: Colors.blue,
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
