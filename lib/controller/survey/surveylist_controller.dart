import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utills/AppColors.dart';
import '../../models/survey_list_model.dart';
import '../../page/Mobile.dart';
import '../../services/user_pref_service.dart';

class SurveyListController extends GetxController {
  final userPrefService = UserPrefService();
  var surveys = <Survey>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://landslide.bdservers.site/api/question'; // Replace with your base URL

  @override
  void onInit() {
    super.onInit();
    fetchSurveys();
    print('check refresh token ${userPrefService.refreshToken}');
  }

  /// Call the Survey API for fetching created survey list
  Future<void> fetchSurveys() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$baseUrl/survey'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '', // Add token to the header
        },
      );
      print('====> $baseUrl/survey');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          surveys.value = List<Survey>.from(
            data['result'].map((e) => Survey.fromJson(e)),
          ).reversed.toList(); // Show last response first
          print('check list: ${surveys.length}');
        } else {
          Get.snackbar("Error", data['message'],
              backgroundColor: AppColors().app_alert_extreme,
              colorText: AppColors().app_secondary
          );
        }
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          return fetchSurveys(); // Retry after refreshing the token
        } else {
          return Get.defaultDialog(
            title: "Session Expired",
            middleText: "Please log in again.",
            textCancel: 'Ok',
            onCancel: () {
              userPrefService.clearUserData();
              Get.offAll(Mobile(), transition: Transition.downToUp);
            },
          );
        }
      } else {
        Get.snackbar("Error", "Failed to load surveys",
            backgroundColor: AppColors().app_alert_extreme,
            colorText: AppColors().app_secondary
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary
      );
    } finally {
      isLoading.value = false;
    }
  }
  /// Call the Survey API for creating a survey
  Future<void> createSurvey(String title) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/survey'),
        body: jsonEncode({"title": title}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '', // Add token to the header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          surveys.value = List<Survey>.from(
            data['result'].map((e) => Survey.fromJson(e)),
          ).reversed.toList();
          Get.back(); // Close dialog
          Get.snackbar("Success", data['message'],
              backgroundColor: AppColors().app_alert_normal,
              colorText: AppColors().app_secondary);
        } else {
          Get.snackbar("Error", data['message'],
              backgroundColor: AppColors().app_alert_extreme,
              colorText: AppColors().app_secondary
          );
        }
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          return createSurvey(title); // Retry after refreshing the token
        } else {
          return Get.defaultDialog(
            title: "Session Expired",
            middleText: "Please log in again.",
            textCancel: 'Ok',
            onCancel: () {
              userPrefService.clearUserData();
              Get.offAll(Mobile(), transition: Transition.downToUp);
            },
          );
        }
      } else {
        Get.snackbar("Error", "Failed to create survey",
            backgroundColor: AppColors().app_alert_extreme,
            colorText: AppColors().app_secondary);
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary);
    } finally {
      isLoading.value = false;
    }
  }
  /// Call the Survey API for deleting created a survey
  Future<void> deleteSurvey(String id) async {
    isLoading.value = true;
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/survey'),
        body: jsonEncode({"sid": id}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '', // Add token to the header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          surveys.removeWhere((s) => s.id == id);
          Get.snackbar("Deleted", data['message'],
              backgroundColor: AppColors().app_alert_moderate ,
              colorText: AppColors().app_secondary);
        } else {
          Get.snackbar("Error", data['message'],
              backgroundColor: AppColors().app_alert_extreme,
              colorText: AppColors().app_secondary);
        }
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          return deleteSurvey(id); // Retry after refreshing the token
        } else {
          return Get.defaultDialog(
            title: "Session Expired",
            middleText: "Please log in again.",
            textCancel: 'Ok',
            onCancel: () {
              userPrefService.clearUserData();
              Get.offAll(Mobile(), transition: Transition.downToUp);
            },
          );
        }
      } else {
        Get.snackbar("Error", "Failed to delete survey",
            backgroundColor: AppColors().app_alert_extreme,
            colorText: AppColors().app_secondary);
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary);
    } finally {
      isLoading.value = false;
    }
  }
}
