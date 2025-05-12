import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/survey_page.dart';

import '../Utills/AppColors.dart';
import '../controller/navigation/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().app_primary,
        foregroundColor: AppColors().app_secondary,
        onPressed: () {
          Get.to(()=> SurveyPage());
          //controller.onItemTapped(4);
        },
        tooltip: "tool".tr,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(Icons.add_task),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal.shade50,
        shape: const CircularNotchedRectangle(),
        surfaceTintColor: Colors.white,
        notchMargin: 20,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavbarItem(Icons.dashboard_outlined, "dashboard", 0),
              buildNavbarItem(Icons.person, "profile_title", 1),
            ],
          ),
        ),
      ),
      body: Obx(()=> controller.screen.elementAt(controller.currentTab.value))
    );
  }


  Widget buildNavbarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => {controller.changePage(index)},
      splashFactory: NoSplash.splashFactory,
      child: Column(
        children: [
          Obx(()=> Icon( icon, color: controller.currentTab == index ? AppColors().app_primary : Colors.black54) ),
          Obx(()=> Text( label.tr, style: TextStyle( fontWeight: controller.currentTab == index ? FontWeight.bold : FontWeight.normal,
              color:  controller.currentTab == index ? AppColors().app_primary : Colors.black54 ),
          ))
        ],
      ),
    );
  }
}
