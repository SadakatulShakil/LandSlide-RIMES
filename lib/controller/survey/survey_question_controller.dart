import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utills/AppColors.dart';
import '../../models/question_model.dart';
import '../../page/Mobile.dart';
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';

class SurveyController extends GetxController {
  final userPrefService = UserPrefService();
  var allQuestions = <SurveyQuestion>[].obs;
  var groupedQuestions = <String, List<SurveyQuestion>>{}.obs;
  var currentStep = 0.obs;
  var isLoading = true.obs;
  late final String surveyId;
  var isValid = false.obs;
  var id = ''.obs;
  var address = ''.obs;
  var district = ''.obs;
  var upazila = ''.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;
  var latAndLon = ''.obs;
  var isLocationUpdated = false.obs;
  var _isFirstTime = false.obs;
  var isSelectedLocation = false.obs;

  final String baseUrl = 'https://landslide.bdservers.site/api/question'; // Replace with your base URL

  @override
  void onInit() {
    super.onInit();
    surveyId = Get.arguments['surveyId'];
    getSharedPrefData();
  }

  ///shared pref location data
  Future getSharedPrefData() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude.value = position.latitude.toStringAsFixed(5);
    longitude.value = position.longitude.toStringAsFixed(5);

    address.value = userPrefService.locationName ?? '';
    district.value = userPrefService.locationDistrict ?? '';
    upazila.value = userPrefService.locationUpazila ?? '';
    id.value = formattedDate;
    fetchQuestions(surveyId);
  }

  ///update given location
  Future updateLocation(LatLng newLocation) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMddHHmmss').format(now);

    isLoading.value = true;
    latitude.value = newLocation.latitude.toStringAsFixed(5);
    longitude.value = newLocation.longitude.toStringAsFixed(5);
    latAndLon.value = 'Lat: ${latitude.value}, Lon: ${longitude.value}';
    print('New Location: ${latAndLon.value}');
    try {
      var response = await http.get(Uri.parse(
          ApiURL.location_latlon + "?lat=" + latitude.value + "&lon=" +
              longitude.value));
      if (response.statusCode != 200) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to fetch location data",
            backgroundColor: AppColors().app_alert_extreme,
            colorText: AppColors().app_secondary);
        return;
      } else {
        var decode = jsonDecode(response.body);
        print('shakil ${decode}');
        id.value = formattedDate;
        address.value = decode['result']['name'];
        upazila.value = decode['result']['upazila'];
        district.value = decode['result']['district'];

        print('shakil111111 ${upazila.value}');
        await userPrefService.saveLocationData(
            latitude.value,
            longitude.value,
            formattedDate,
            decode['result']['name'],
            decode['result']['upazila'],
            decode['result']['district']
        );
        isLoading.value = false;
        fetchQuestions(surveyId);
      }
    } catch (e) {
      print(e.toString());
    }
    //isLoading.value = false;
  }

  /// Call the API for return fetched questions
  Future<List<SurveyQuestion>> fetchSurveyQuestions(int sId) async {

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/survey_questions?id=$sId'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": userPrefService.userToken ?? '',
            // Add token to the header},
          }
      );

      if (response.statusCode == 200) {
        final decode = json.decode(response.body);
        final List data = decode['result'];
        return data.map((item) => SurveyQuestion.fromJson(item)).toList();
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          fetchQuestions(surveyId); // Retry after refreshing the token
        } else {
          Get.snackbar('Session expired', 'Please log in again.',
              backgroundColor: AppColors().app_alert_moderate,
              colorText: AppColors().app_secondary,
          );
        }
      } else {
        throw Exception('Failed to load survey questions');
      }
    } catch (e) {
      throw Exception('Failed to load survey questions');
    }
    return [];
  }

  /// Call the API for save fetched questions as grouped
  void fetchQuestions(String surveyId) async {
    isLoading.value = true;
    int sId = int.tryParse(surveyId) ?? 0;
    try {
      final questions = await fetchSurveyQuestions(sId);
      for (var q in questions) {
        if (q.title.toLowerCase().contains("landslide id")) {
          print('valueOfDistrict: ${q.answer}');
          q.answer = id.value;
        } else if (q.title.toLowerCase().contains("district")) {
          q.answer = district.value;
        } else if (q.title.toLowerCase().contains("upazila")) {
          q.answer = upazila.value;
        } else if (q.title.toLowerCase().contains("latitude")) {
          q.answer = latitude.value;
        } else if (q.title.toLowerCase().contains("longitude")) {
          q.answer = longitude.value;
        }
      }

      allQuestions.assignAll(questions);

      final Map<String, List<SurveyQuestion>> grouped = {};
      for (var question in questions) {
        grouped.putIfAbsent(question.group, () => []).add(question);
      }
      groupedQuestions.assignAll(grouped);
    } finally {
      isLoading.value = false;
    }
  }

  ///upload image Api
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
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          return uploadImage(imageFile); // Retry after refreshing the token
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
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  /// Next step click and call partial answer submission
  void nextStep() async {
    if (currentStep.value < groupedQuestions.length - 1) currentStep++;
    isValid.value = false;
    await submitAnswers();
  }

  /// Make the submitted answer payload as Raw data format
  List<Map<String, dynamic>> _buildAnswerPayload() {
    return groupedQuestions.values
        .expand((questions) => questions)
        .map((q) {
      dynamic answer;

      if (q.type == 'Boolean') {
        // Convert string/bool/null to a valid bool
        if (q.answer == true || q.answer == "true") {
          answer = true;
        } else {
          answer = false;
        }
      } else if (q.answer is List) {
        answer = (q.answer as List).join(',');
      } else {
        answer = q.answer?.toString();
      }

      return {
        "id": q.id,
        "answer": answer.toString(),
      };
    }).toList();
  }

  /// Call the answer submission API
  Future<void> submitAnswers() async {
    final payload = _buildAnswerPayload();
    final url = Uri.parse("$baseUrl/survey_questions");

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '',
          // Add token to the header},
        },
        body: jsonEncode(payload),
      );

      print('responseCode Answer: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception("Failed to submit answers");
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          return submitAnswers(); // Retry after refreshing the token
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
      }

      print("Answers submitted: ${response.body}");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit answers: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary);
    }
    print("Submitting answers: $payload");

    await Future.delayed(Duration(milliseconds: 500)); // simulate API
  }

  /// Call the stepper previous button
  void prevStep() {
    if (currentStep.value > 0) currentStep--;
  }

  /// Call the final answer submission API
  void submitFinal() async {
    isLoading.value = true;
    try {
      await submitAnswers();
      await completeSurvey();

      Get.snackbar("Success", "survey_success".tr,
          backgroundColor: AppColors().app_alert_normal,
          colorText: AppColors().app_secondary);
    } catch (e) {
      Get.snackbar("Error", "Failed to submit answers: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary);
    } finally {
      isLoading.value = false;
    }
  }

  /// Complete the answer submission API
  Future<void> completeSurvey() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(now);
    final data = {
      "sid": int.tryParse(surveyId) ?? 0,
      "title": "My Survey ($surveyId) - $formattedDate",
      "status": "complete",
    };
    final url = Uri.parse("$baseUrl/survey");

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '',
          // Add token to the header},
        },
        body: jsonEncode(data),
      );

      print('ResponseCode: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception("Failed to submit final answers");
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userPrefService.refreshAccessToken();
        if (refreshed) {
          return completeSurvey(); // Retry after refreshing the token
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
      }

      print("Final Answers submitted: ${response.body}");
      Get.back(result: 'refresh');
    } catch (e) {
      Get.snackbar("Error", "Failed to complete answers: $e",
          backgroundColor: AppColors().app_alert_extreme,
          colorText: AppColors().app_secondary
      );
    }

    print("Completing survey: $data");

    await Future.delayed(Duration(milliseconds: 500)); // simulate API
  }

  ///Check readonly field
  bool isReadOnlyField(String title) {
    final lower = title.toLowerCase();
    return lower.contains('landslide id') ||
        lower.contains('district') ||
        lower.contains('upazila') ||
        lower.contains('latitude') ||
        lower.contains('longitude');
  }
}

