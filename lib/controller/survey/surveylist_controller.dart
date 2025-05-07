import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/survey_list_model.dart';

class SurveyListController extends GetxController {
  var surveys = <Survey>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://landslide.bdservers.site/api/question'; // Replace with your base URL
  final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjIiLCJmdWxsbmFtZSI6Ilx1MDliOFx1MDliZVx1MDlhN1x1MDliZVx1MDliMFx1MDlhMyBcdTA5YWNcdTA5Y2RcdTA5YWZcdTA5YWNcdTA5YjlcdTA5YmVcdTA5YjBcdTA5OTVcdTA5YmVcdTA5YjBcdTA5YzAiLCJlbWFpbCI6IiIsIm1vYmlsZSI6IjAxNzUxMzMwMzk0IiwiYWRkcmVzcyI6IiIsInBob3RvIjoiMi5wbmciLCJ0eXBlIjoiYWR2YW5jZWQiLCJjcmVhdGVkX2F0IjoiMjAyNS0wMy0xMiAxNDoyMTo1MyIsInVwZGF0ZWRfYXQiOiIyMDI1LTA1LTA1IDA5OjQzOjQ1IiwiQVBJX1RJTUUiOjE3NDY1OTYwMzAsImlhdCI6MTc0NjU5NjAzMCwiZXhwIjoxNzQ2NjgyNDMwfQ.oP5GSE3ZuiG_A1kgonWq_JlG6sB-i7su-3APOJNQqoo'; // Replace with token

  @override
  void onInit() {
    super.onInit();
    fetchSurveys();
  }

  /// Call the Survey API for fetching created survey list
  Future<void> fetchSurveys() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$baseUrl/survey'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add token to the header
        },
      );
      print('====> $baseUrl/survey');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          surveys.value = List<Survey>.from(
            data['result'].map((e) => Survey.fromJson(e)),
          );
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to load surveys");
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
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
          "Authorization": token, // Add token to the header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          surveys.value = List<Survey>.from(
            data['result'].map((e) => Survey.fromJson(e)),
          );
          Get.back(); // Close dialog
          Get.snackbar("Success", data['message']);
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to create survey");
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
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
          "Authorization": token, // Add token to the header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          surveys.removeWhere((s) => s.id == id);
          Get.snackbar("Deleted", data['message']);
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to delete survey");
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
