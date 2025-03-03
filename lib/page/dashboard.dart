import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanslide_report/page/report_form_page.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => ReportFormPage(), transition: Transition.rightToLeft);
        },
        label: Text('Report Landslide'),
        icon: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Dashboard')),
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
              _buildLandslidePieChart(),
              SizedBox(height: 30),
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
        side: const BorderSide(color: Colors.green, width: 1.0),
      ),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monday',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '12th March 2025',
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

  // Landslide Bar Chart
  Widget _buildLandslideBarChart() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Landslide Frequency', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 5, width: 20),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Landslide Pie Chart
  Widget _buildLandslidePieChart() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Landslide Types Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieChartData,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
