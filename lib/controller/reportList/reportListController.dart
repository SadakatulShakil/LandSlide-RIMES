import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utills/AppColors.dart';
import '../../database_helper/database.dart';
import '../../database_helper/entities/survey_questions_entities.dart';
import '../../models/question_model.dart';
import '../../models/survey_list_model.dart';
import '../../page/Mobile.dart';
import '../../services/location_service.dart';
import '../../services/user_pref_service.dart';
import '../../services/db_service.dart';
import '../network/network_controller.dart';

class EventListController extends GetxController {
  final userPrefService = UserPrefService();
  final dbService = Get.find<DBService>();
  var surveys = <Survey>[].obs;
  var isLoading = false.obs;
  final NetworkController internetController = Get.put(NetworkController());

  final String baseUrl = 'https://landslide.bdservers.site/api/question';

  @override
  void onInit() {
    super.onInit();
    getLocation();
    fetchSurveys();
    print('check refresh token ${userPrefService.refreshToken}');
  }

  Future<void> getLocation() async {
    await LocationService().getLocation();
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Get.defaultDialog(
        title: "Location Disabled",
        content: const Text("Please enable location services."),
        textConfirm: "Open Settings",
        textCancel: "Cancel",
        onConfirm: () async {
          await Geolocator.openLocationSettings();
          Get.back();
        },
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Get.defaultDialog(
          title: "Permission Needed",
          content: const Text("Location permission is required to proceed."),
          textConfirm: "Try Again",
          textCancel: "Cancel",
          onConfirm: () async {
            Get.back();
            await getCurrentLocation(); // Try again
          },
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Get.defaultDialog(
        title: "Permission Blocked",
        content: const Text(
            "Location permission is permanently denied. Please enable it from App Info > Permissions."),
        textConfirm: "Open App Settings",
        textCancel: "Cancel",
        onConfirm: () async {
          await openAppSettings();
          Get.back();
        },
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  Future<void> fetchSurveys() async {
    surveys.value = await dbService.getSurveysOffline();
  }

  Future<void> createSurvey(String title) async {

    final now = DateTime.now().toIso8601String();
    final offlineSurvey = Survey(
      id: now.hashCode.toString(),
      title: title,
      status: 'incomplete',
    );
    surveys.insert(0, offlineSurvey);
    await dbService.saveSurvey(offlineSurvey);
    await dbService.createSurveyQuestionSet(now.hashCode.toString());
    Get.back();
    Get.snackbar("Offline", "Survey saved locally.",
        backgroundColor: AppColors().app_alert_normal,
        colorText: AppColors().app_secondary);
  }

  Future<void> deleteSurvey(String id) async {
    surveys.removeWhere((s) => s.id == id);
    await dbService.deleteSurveyLocally(id);
    Get.snackbar("Offline", "Survey deleted locally.",
        backgroundColor: AppColors().app_alert_moderate,
        colorText: AppColors().app_secondary);
  }

  Future<void> syncSurvey(String surveyId, String title) async {
    print('Syncing survey: $surveyId');
    try {
      final isConnected = internetController.isNetworkWorking.value;
      print('Internet connected: $isConnected');
      if (!isConnected) {
        Get.snackbar("Offline", "Please connect to internet to sync data",
            backgroundColor: AppColors().app_alert_moderate,
            colorText: AppColors().app_secondary);
        return;
      }

      final unsyncedQuestions = await dbService.getUnsyncedQuestionsBySurvey(surveyId);

      print('Unsynced Questions: ${unsyncedQuestions}');
      if (unsyncedQuestions.isEmpty) {
        Get.snackbar("Synced", "All data already synced.",
            backgroundColor: AppColors().app_alert_normal,
            colorText: AppColors().app_secondary);
        return;
      }

      // Handle image upload
      for (var q in unsyncedQuestions) {
        if (q.type == 'Array' && q.answer != null && q.answer!.contains('/')) {
          final localPaths = q.answer!.split(',').map((e) => e.trim()).toList();
          List<String> uploadedUrls = [];

          for (String path in localPaths) {
            if (path.isEmpty) continue;
            final file = File(path);
            if (await file.exists()) {
              final url = await uploadImage(file);
              if (url != null) uploadedUrls.add(url);
            }
          }

          q.answer = uploadedUrls.join(',');
          print('Uploaded URLs: ${q.answer}');
        }
      }
      final timestamp = DateTime.now().toIso8601String();
      // Submit updated answers
      final payload = {
        "survey": {
          "id": surveyId,
          "title": title,
          "created_at": timestamp,
        },
        "answer": unsyncedQuestions.map((q) => {
          "questionsId": q.id,
          "answer": q.answer ?? '',
          "created_at": timestamp,
        }).toList()
      };

      final response = await http.post( //  You must use POST, not PUT here based on the structure
        Uri.parse('https://landslide.bdservers.site/api/question/offline'), // Adjust endpoint accordingly
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '',
        },
        body: jsonEncode(payload),
      );

      print('Response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        // Mark all as synced locally
        for (var q in unsyncedQuestions) {
          await dbService.markQuestionAsSynced(q.uid);
        }

        await completeSurvey(surveyId);

        Get.snackbar("Success", "Survey synced successfully",
            backgroundColor: AppColors().app_alert_normal,
            colorText: AppColors().app_secondary);
      } else {
        print(' Sync failed: ${response.statusCode} ${response.body}');
        Get.snackbar("Error", "Survey sync failed",
            backgroundColor: AppColors().app_alert_extreme,
            colorText: AppColors().app_secondary);
      }
    } catch (e) {
      print(' Sync Error: $e');
      Get.snackbar("Error", "Failed to sync survey: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary);
    }
  }

  Future<void> completeSurvey(String surveyId) async {
    print('Completing survey: $surveyId');
    final now = DateTime.now();
    try {
      await dbService.updateSurveyStatus(surveyId, 'complete');
      print(" Survey $surveyId marked as complete in offline DB.");
    } catch (e) {
      print(" Failed to update local survey status: $e");
    }

    final formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(now);
    final data = {
      "sid": int.tryParse(surveyId) ?? 0,
      "title": "My Survey (${surveyId}) - $formattedDate",
      "status": "complete",
    };

    final url = Uri.parse("$baseUrl/survey");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": userPrefService.userToken ?? '',
      },
      body: jsonEncode(data),
    );

    print('Complete Survey Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      fetchSurveys();
    } else {
      throw Exception("Failed to complete survey");
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse("$baseUrl/upload");

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = userPrefService.userToken ?? ''
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final resString = await response.stream.bytesToString();
        final resJson = jsonDecode(resString);
        return resJson['result'];
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

}
