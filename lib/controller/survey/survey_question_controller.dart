import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../models/question_model.dart';
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
  var isLocationUpdated =  false.obs;
  var _isFirstTime = false.obs;
  var isSelectedLocation =  false.obs;

   final String baseUrl = 'https://landslide.bdservers.site/api/question'; // Replace with your base URL
  //final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjIiLCJmdWxsbmFtZSI6Ilx1MDliOFx1MDliZVx1MDlhN1x1MDliZVx1MDliMFx1MDlhMyBcdTA5YWNcdTA5Y2RcdTA5YWZcdTA5YWNcdTA5YjlcdTA5YmVcdTA5YjBcdTA5OTVcdTA5YmVcdTA5YjBcdTA5YzAiLCJlbWFpbCI6IiIsIm1vYmlsZSI6IjAxNzUxMzMwMzk0IiwiYWRkcmVzcyI6IiIsInBob3RvIjoiMi5wbmciLCJ0eXBlIjoiYWR2YW5jZWQiLCJjcmVhdGVkX2F0IjoiMjAyNS0wMy0xMiAxNDoyMTo1MyIsInVwZGF0ZWRfYXQiOiIyMDI1LTA1LTA1IDA5OjQzOjQ1IiwiQVBJX1RJTUUiOjE3NDcwMjc1MTIsImlhdCI6MTc0NzAyNzUxMiwiZXhwIjoxNzQ3MTEzOTEyfQ.c7cTLsQsBxzLUhlrxcOZy1PCyMVESs9g31doe3E7iyE'; // Replace with token

  @override
  void onInit() {
    super.onInit();
    surveyId = Get.arguments['surveyId'];
    getSharedPrefData();
  }

  ///shared pref location data
  Future getSharedPrefData() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude.value = position.latitude.toStringAsFixed(5);
    longitude.value = position.longitude.toStringAsFixed(5);

    address.value = userPrefService.locationName ?? '';
    district.value = userPrefService.locationDistrict ?? '';
    upazila.value = userPrefService.locationUpazila ?? '';
    id.value = userPrefService.locationId ?? '';
    fetchQuestions(surveyId);
  }
  ///update given location
  Future updateLocation(LatLng newLocation) async{

    isLoading.value = true;
    latitude.value = newLocation.latitude.toStringAsFixed(5);
    longitude.value = newLocation.longitude.toStringAsFixed(5);
    latAndLon.value = 'Lat: ${latitude.value}, Lon: ${longitude.value}';
    print('New Location: ${latAndLon.value}');
    try {
      var response = await http.get(Uri.parse(ApiURL.location_latlon + "?lat=" + latitude.value + "&lon=" + longitude.value));
      if(response.statusCode != 200) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to fetch location data");
        return;
      }else {
        var decode = jsonDecode(response.body);
        print('shakil ${decode}');
        id.value = decode['result']['id'];
        address.value = decode['result']['name'];
        upazila.value = decode['result']['upazila'];
        district.value = decode['result']['district'];

        print('shakil111111 ${upazila.value}');
        await userPrefService.saveLocationData(
            latitude.value,
            longitude.value,
            decode['result']['id'],
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
    final response = await http.get(Uri.parse('$baseUrl/survey_questions?id=$sId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": userPrefService.userToken ?? '', // Add token to the header},
        }
    );

    if (response.statusCode == 200) {
      final decode = json.decode(response.body);
      final List data = decode['result'];
      return data.map((item) => SurveyQuestion.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load survey questions');
    }
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
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }
  /// Next step click and call partial answer submission
  void nextStep() async{
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
          "Authorization": userPrefService.userToken ?? '', // Add token to the header},
        },
        body: jsonEncode(payload),
      );

      print('responseCode Answer: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception("Failed to submit answers");
      }

      print("Answers submitted: ${response.body}");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit answers: $e");
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

      Get.snackbar("Success", "Survey submitted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit answers: $e");
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
          "Authorization": userPrefService.userToken ?? '', // Add token to the header},
        },
        body: jsonEncode(data),
      );

      print('ResponseCode: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception("Failed to submit final answers");
      }

      print("Final Answers submitted: ${response.body}");
      Get.back(result: 'refresh');
    } catch (e) {
      Get.snackbar("Error", "Failed to complete answers: $e");
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

