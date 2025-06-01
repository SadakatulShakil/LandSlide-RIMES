import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Utills/AppColors.dart';
import '../../database_helper/entities/survey_questions_entities.dart';
import '../../models/question_model.dart';
import '../../page/Mobile.dart';
import '../../services/api_urls.dart';
import '../../services/db_service.dart';
import '../../services/user_pref_service.dart';

class SurveyQController extends GetxController {
  final userPrefService = UserPrefService();
  final dbService = Get.find<DBService>();

  var allQuestions = <SurveyQuestion>[].obs;
  var groupedQuestions = <String, List<SurveyQuestion>>{}.obs;
  var currentStep = 0.obs;
  var isLoading = true.obs;
  var isValid = false.obs;

  var surveyId = ''.obs;
  var id = ''.obs;
  var address = ''.obs;
  var district = ''.obs;
  var upazila = ''.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;
  var latAndLon = ''.obs;
  var isLocationUpdated = false.obs;

  final String baseUrl = 'https://landslide.bdservers.site/api/question';

  @override
  void onInit() {
    super.onInit();
    surveyId.value = Get.arguments['surveyId']; // Get survey ID on navigation
    print('Survey ID: ${surveyId.value}');
    getSharedPrefData();
  }

  Future getSharedPrefData() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude.value = position.latitude.toStringAsFixed(5);
    longitude.value = position.longitude.toStringAsFixed(5);
    address.value = userPrefService.locationName ?? '';
    district.value = userPrefService.locationDistrict ?? '';
    upazila.value = userPrefService.locationUpazila ?? '';
    id.value = formattedDate;

    print('Location: Lat: ${district.value}, Lon: ${upazila.value}');
    await loadSurveyQuestionsForId(surveyId.value);
  }

  Future<void> loadSurveyQuestionsForId(String surveyId) async {
    isLoading.value = true;
    try {
      final localQuestions = await dbService.getQuestionsForSurvey(surveyId);
      List<SurveyQuestion> finalQuestions;

      if (localQuestions.isNotEmpty) {
        finalQuestions = localQuestions;
      } else {
        final fetched = await fetchSurveyQuestions(); // master
        // Save with surveyId
        await dbService.saveSurveyQuestions(
          fetched.map((e) => SurveyQuestionEntity.fromModel(e, surveyId: surveyId)).toList(),
        );
        finalQuestions = fetched;
      }

      // Always set default answers (even for local questions)
      for (var q in finalQuestions) {
        final title = q.title.toLowerCase();
        if (title.contains("landslide id")) q.answer = id.value;
        if (title.contains("district")) q.answer = district.value;
        if (title.contains("upazila")) q.answer = upazila.value;
        if (title.contains("latitude")) q.answer = latitude.value;
        if (title.contains("longitude")) q.answer = longitude.value;
      }

      allQuestions.assignAll(finalQuestions);
      groupedQuestions.assignAll(_groupBy(finalQuestions));
    } catch (e) {
      print('❌ Error loading questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<SurveyQuestion>> fetchSurveyQuestions() async {
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": userPrefService.userToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final decode = json.decode(response.body);
      final List data = decode['result'];
      return data.map((item) => SurveyQuestion.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load survey questions');
    }
  }

  Map<String, List<SurveyQuestion>> _groupBy(List<SurveyQuestion> questions) {
    final map = <String, List<SurveyQuestion>>{};
    for (var q in questions) {
      map.putIfAbsent(q.group, () => []).add(q);
    }
    return map;
  }

  Future<void> updateLocation(LatLng newLocation) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
    latitude.value = newLocation.latitude.toStringAsFixed(5);
    longitude.value = newLocation.longitude.toStringAsFixed(5);
    latAndLon.value = 'Lat: ${latitude.value}, Lon: ${longitude.value}';

    try {
      final response = await http.get(Uri.parse('${ApiURL.location_latlon}?lat=${latitude.value}&lon=${longitude.value}'));
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        id.value = formattedDate;
        address.value = decode['result']['name'];
        upazila.value = decode['result']['upazila'];
        district.value = decode['result']['district'];
        await userPrefService.saveLocationData(latitude.value, longitude.value, formattedDate, address.value, upazila.value, district.value);
        await loadSurveyQuestionsForId(surveyId.value); // Reload with updated data
      }
    } catch (e) {
      print('Location error: $e');
    }
  }

  Future<void> nextStep() async {
    if (currentStep.value < groupedQuestions.length - 1) currentStep++;
    isValid.value = false;
    await saveAnswersOffline();
  }

  Future<void> saveAnswersOffline() async {
    final updated = groupedQuestions.values.expand((e) => e).toList();
    final entities = updated.map((e) => SurveyQuestionEntity.fromModel(e, surveyId: surveyId.value)).toList();
    print('Answers: ${entities.map((e) => e.toModel().toJson()).toList()}');
    await dbService.saveSurveyAnswers(surveyId.value, entities);
  }

  Future<void> submitFinal() async {
    Get.back(result: 'refresh');
    isLoading.value = true;
    try {
      await saveAnswersOffline();

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

  Future<String?> saveImageOffline(File imageFile) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = imageFile.path.split('/').last;
      final saved = await imageFile.copy('${dir.path}/$fileName');
      return saved.path;
    } catch (e) {
      print('Image save error: $e');
      return null;
    }
  }

  Future<List<String>> uploadOfflineImages(List<String> paths) async {
    List<String> urls = [];
    for (String path in paths) {
      final file = File(path);
      final url = await uploadImage(file);
      if (url != null) urls.add(url);
    }
    return urls;
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

  void prevStep() {
    if (currentStep.value > 0) currentStep--;
  }

  bool isReadOnlyFieldOnline(String title) {
    final lower = title.toLowerCase();
    return lower.contains('landslide id') ||
        lower.contains('district') ||
        lower.contains('upazila') ||
        lower.contains('latitude') ||
        lower.contains('longitude');
  }

  bool isReadOnlyFieldOffline(String title) {
    final lower = title.toLowerCase();
    return lower.contains('landslide id') ||
        lower.contains('latitude') ||
        lower.contains('longitude');
  }
}