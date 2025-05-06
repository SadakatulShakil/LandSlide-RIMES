// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../models/question_model.dart';
//
// class SurveyQuestionController extends GetxController {
//   var groupedQuestions = <String, List<QuestionModel>>{}.obs;
//   var answers = <String, dynamic>{}.obs;
//   var isLoading = true.obs;
//   var currentStep = 0.obs;
//   late final String surveyId;
//
//   final String baseUrl = 'https://landslide.bdservers.site/api/question'; // Replace with your base URL
//   final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjIiLCJmdWxsbmFtZSI6Ilx1MDliNlx1MDliZVx1MDk5NVx1MDliZlx1MDliMiBcdTA5ODZcdTA5YWZcdTA5YWUiLCJlbWFpbCI6InNoYWtpbEBnbWFpbC5jb20iLCJtb2JpbGUiOiIwMTc1MTMzMDM5NCIsImFkZHJlc3MiOiJQaXJnYWNjaGEsIFJhbmdwdXIsIFJhbmdwdXIiLCJwaG90byI6IjIucG5nIiwidHlwZSI6ImNvbW1vbiIsImNyZWF0ZWRfYXQiOiIyMDI1LTAzLTEyIDE0OjIxOjUzIiwidXBkYXRlZF9hdCI6IjIwMjUtMDQtMDcgMTM6MjM6NTciLCJBUElfVElNRSI6MTc0NjM0MTYyNiwiaWF0IjoxNzQ2MzQxNjI2LCJleHAiOjE3NDY0MjgwMjZ9.Buqdb15wNo6NruvtY9PIMKaJAc8ikYRjkdldVkLepdg'; // Replace with token
//
//   @override
//   void onInit() {
//     super.onInit();
//     surveyId = Get.arguments['surveyId']; // Get the surveyId from arguments
//     fetchQuestions(surveyId); // Fetch questions based on surveyId
//   }
//
//   Future<void> fetchQuestions(String surveyId) async {
//     isLoading.value = true;
//     int sId = int.tryParse(surveyId) ?? 0;
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/survey_questions?id=$sId'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": token, // Add token to the header
//         },
//       );
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         List<QuestionModel> questions = data.map((e) => QuestionModel.fromJson(e)).toList();
//
//         // Group by 'group' field
//         final grouped = <String, List<QuestionModel>>{};
//         for (var q in questions) {
//           grouped.putIfAbsent(q.group, () => []).add(q);
//         }
//
//         groupedQuestions.value = grouped;
//       } else {
//         Get.snackbar('Error', 'Failed to load questions');
//       }
//       isLoading(false);
//     } catch (e) {
//       print('Error:  ${e.toString()}');
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void updateAnswer(String id, dynamic value) {
//     answers[id] = value;
//   }
//
//   void submitSurvey() {
//     print("Survey Responses:");
//     // You can post responses to the API here
//   }
//
//   void nextStep() {
//     if (currentStep.value < groupedQuestions.length - 1) {
//       currentStep.value++;
//     }
//   }
//
//   void previousStep() {
//     if (currentStep.value > 0) {
//       currentStep.value--;
//     }
//   }
// }
//

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/question_model.dart';

class SurveyController extends GetxController {
  var allQuestions = <SurveyQuestion>[].obs;
  var groupedQuestions = <String, List<SurveyQuestion>>{}.obs;
  var currentStep = 0.obs;
  var isLoading = true.obs;
  late final String surveyId;
  var isValid = false.obs;

   final String baseUrl = 'https://landslide.bdservers.site/api/question'; // Replace with your base URL
   final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjIiLCJmdWxsbmFtZSI6Ilx1MDliOFx1MDliZVx1MDlhN1x1MDliZVx1MDliMFx1MDlhMyBcdTA5YWNcdTA5Y2RcdTA5YWZcdTA5YWNcdTA5YjlcdTA5YmVcdTA5YjBcdTA5OTVcdTA5YmVcdTA5YjBcdTA5YzAiLCJlbWFpbCI6IiIsIm1vYmlsZSI6IjAxNzUxMzMwMzk0IiwiYWRkcmVzcyI6IiIsInBob3RvIjoiMi5wbmciLCJ0eXBlIjoiYWR2YW5jZWQiLCJjcmVhdGVkX2F0IjoiMjAyNS0wMy0xMiAxNDoyMTo1MyIsInVwZGF0ZWRfYXQiOiIyMDI1LTA1LTA1IDA5OjQzOjQ1IiwiQVBJX1RJTUUiOjE3NDY0MzkxOTAsImlhdCI6MTc0NjQzOTE5MCwiZXhwIjoxNzQ2NTI1NTkwfQ.OONV9kf19eNay5X70ropys5tDxGADXNhgeSTDhT6r1Q'; // Replace with token


  @override
  void onInit() {
    super.onInit();
    surveyId = Get.arguments['surveyId'];
    fetchQuestions(surveyId);
  }

  /// Call the API for return fetched questions
  Future<List<SurveyQuestion>> fetchSurveyQuestions(int sId) async {
    final response = await http.get(Uri.parse('$baseUrl/survey_questions?id=$sId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add token to the header},
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
        .map((q) => {
      "id": q.id,
      "answer": q.answer is List ? (q.answer as List).join(',') : q.answer.toString()
    })
        .toList();
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
          "Authorization": token, // Add token to the header},
        },
        body: jsonEncode(payload),
      );

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

    await submitAnswers();
    await completeSurvey();

    Get.snackbar("Success", "Survey submitted successfully!");
    // Navigate or reset
  }
  /// Complete the answer submission API
  Future<void> completeSurvey() async {
    final data = {
      "sid": int.tryParse(surveyId) ?? 0,
      "title": "Survey for ${DateTime.now()} NEW",
      "status": "complete",
    };
    final url = Uri.parse("$baseUrl/survey");

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add token to the header},
        },
        body: data,
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to submit final answers");
      }

      print("Final Answers submitted: ${response.body}");
    } catch (e) {
      Get.snackbar("Error", "Failed to complete answers: $e");
    }

    print("Completing survey: $data");

    await Future.delayed(Duration(milliseconds: 500)); // simulate API
  }
}

