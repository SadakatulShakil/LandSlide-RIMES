import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../services/api_service.dart';
import '../../services/user_pref_service.dart';

class DashboardController extends GetxController {

  final userService = UserPrefService();
  final List<dynamic> dashboardMenu = [
    {
      "name": "dashboard_weather_forecast",
      "image": "weather_forecast.png",
      "page": "weather-forecast"
    },
    {
      "name": "dashboard_weather_alert",
      "image": "weather_alert.png",
      "page": "weather-alert"
    },
    {
      "name": "dashboard_flood_forecast",
      "image": "flood_forecast.png",
      "page": "flood-forecast"
    },
    {
      "name": "dashboard_crop_advisory",
      "image": "crop_advisory.png",
      "page": "crop-advisory"
    },
    {
      "name": "dashboard_pest_disease",
      "image": "pest_disease_alert.png",
      "page": "crop-disease"
    },
    {
      "name": "dashboard_pest_disease_information",
      "image": "pest_disease_information.png",
      "page": "pest-disease-alerts"
    },
    {
      "name": "dashboard_task_reminder",
      "image": "task_reminder.png",
      "page": "task-reminder"
    },
    {
      "name": "dashboard_advisory_bulletin",
      "image": "advisory_bulletin.png",
      "page": "bulletins"
    },
    {
      "name": "dashboard_online_library",
      "image": "online_library.png",
      "page": "elibrary"
    },
    // {
    //   "name": "dashboard_farm_metrics",
    //   "image": "farm_metrics.png",
    //   "page": "farm-metrics"
    // }
  ];

  var initTime = "Good Morning".obs;
  late var fullname = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var photo = "".obs;

  //weather
  var currentLocationId = "".obs;
  var currentLocationName = "".obs;
  dynamic forecast = [].obs;
  dynamic notification = [].obs;
  var notificationValue = "".obs;
  var cLocationUpazila = "".obs;
  var cLocationDistrict = "".obs;
  var isForecastLoading = false.obs;


  @override
  void onInit() {
    getTime();
    getSharedPrefData();
  }

  Future onRefresh() async {
    await getTime();
    await getSharedPrefData();
  }

  Future openModule(index) async {
    var result = Get.toNamed(dashboardMenu[index]['page']);
    if(result == 'update') {
      Get.snackbar("Back Button", "Back button pressed", snackPosition: SnackPosition.BOTTOM, padding: EdgeInsets.only(bottom: 16)).show();
    }
  }

  getTime() {
    var currentHour = DateTime.timestamp();
    var hour = int.parse(currentHour.toString().substring(11, 13)) + 6;
    if(hour > 23) {
      hour = hour - 23;
    }
    if (hour >= 5 && hour < 12) {
      initTime.value = "dashboard_time_good_morning".tr;
    } else if (hour >= 12 && hour < 15) {
      initTime.value = "dashboard_time_good_noon".tr;
    } else if (hour >= 15 && hour < 17) {
      initTime.value = "dashboard_time_good_afternoon".tr;
    } else if (hour >= 17 && hour < 19) {
      initTime.value = "dashboard_time_good_evening".tr;
    } else {
      initTime.value = "dashboard_time_good_night".tr;
    }
  }

  Future getSharedPrefData() async {
    currentLocationId.value = userService.locationId ?? '';
    fullname.value = userService.userName ?? '';
    mobile.value = userService.userMobile ?? '';
    email.value = userService.userEmail ?? '';
    currentLocationName.value = userService.locationName ?? '';
    cLocationDistrict.value = userService.locationDistrict ?? '';
    cLocationUpazila.value = userService.locationUpazila ?? '';
    // type.value = userService.userType ?? '';

    if (userService.userPhoto != null && userService.userPhoto!.startsWith("https://landslide.bdservers.site/")) {
      // Case 1: Already a full URL, use it as is.
      photo.value = userService.userPhoto!;
    } else if (userService.userPhoto != null && userService.userPhoto!.startsWith("/assets/auth/")) {
      // Case 2: User photo starts with "/assets/auth/", prepend base URL
      photo.value = "${ApiURL.base_url_image}${userService.userPhoto!}";
    } else if (userService.userPhoto != null && !userService.userPhoto!.contains("/assets/auth/")) {
      // Case 3: Only contains image name like "image.png", add "/assets/auth/" and base URL
      photo.value = "${ApiURL.base_url_image}/assets/auth/${userService.userPhoto!}";
    } else {
      // Case 4: Handle null or empty userPhoto (fallback)
      photo.value = "${ApiURL.base_url_image}/assets/auth/default.png"; // Use default image
    }

    getForecast(currentLocationId.value);

  }

  Future getNotifications() async {
    var token = userService.userToken ?? '';
    var lang = Get.locale?.languageCode;

    Map<String, String> requestHeaders = {
      'Authorization': token.toString(),
      'Accept-Language': lang.toString()
    };

    // var response = await http.get(Uri.parse(ApiURL.notification_notifications), headers: requestHeaders);
    // dynamic decode = jsonDecode(response.body) ?? [];
    // notification.value = decode['result'] ?? [];
    // var seen = 0;
    // notification.value.forEach((item){
    //   item['seen'] == "1" ? seen++ : seen = seen;
    // });
    // notificationValue.value = "${notification.value.length - seen}";
  }

  Future getForecast(locationId) async {
    isForecastLoading.value = true;
    var token = userService.userToken ?? '';
    var lang = Get.locale?.languageCode;

    Map<String, String> requestHeaders = {
      'Authorization': token.toString(),
      'Accept-Language': lang.toString()
    };
    var response = await http.get(Uri.parse(ApiURL.currentforecast + "?location=$locationId"), headers: requestHeaders);

    dynamic decode = jsonDecode(response.body);
    forecast.value = decode['result'];
    isForecastLoading.value = false;
  }

  Future gotoNotificationPage() async{
    await Get.toNamed('notifications');
  }

  Color getStageCardColor(String item) {
    if(item == 'completed') {
      return Color(0xFFE1FFDF);
    } else if(item == 'ongoing') {
      return Color(0xFFFFF3BB);
    } else if(item == 'upcoming') {
      return Color(0xFFB2B2B2);
    } else {
      return Color(0xFFB2B2B2);
    }
  }

}