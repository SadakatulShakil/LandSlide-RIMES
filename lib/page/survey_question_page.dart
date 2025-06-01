import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lanslide_report/Utills/AppColors.dart';

import '../controller/event/event_question_controller.dart';
import '../controller/network/network_controller.dart';
import '../models/question_model.dart';
import 'map_page.dart';

class SurveyQuestionPage extends StatefulWidget {
  @override
  State<SurveyQuestionPage> createState() => _SurveyQuestionPageState();
}

class _SurveyQuestionPageState extends State<SurveyQuestionPage> {
  final controller = Get.put(SurveyQController());
  final NetworkController internetController = Get.put(NetworkController());

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("survey_question".tr),
        backgroundColor: AppColors().app_primary_bg,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final groupKeys = controller.groupedQuestions.keys.toList();

        if (groupKeys.isEmpty) {
          return Center(child: Text("no_questions".tr));
        }

        final currentGroup = groupKeys[controller.currentStep.value];
        final questions = controller.groupedQuestions[currentGroup]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              child: Theme(
                data: ThemeData(
                  colorScheme:
                      ColorScheme.light(primary: AppColors().app_primary),
                ),
                child: Stepper(
                  elevation: 0,
                  currentStep: controller.currentStep.value,
                  type: StepperType.horizontal,
                  controlsBuilder: (context, _) => const SizedBox.shrink(),
                  steps: List.generate(groupKeys.length, (index) {
                    return Step(
                      title: const SizedBox(),
                      content: const SizedBox(),
                      state: controller.currentStep.value > index
                          ? StepState.complete
                          : StepState.indexed,
                      isActive: controller.currentStep.value == index,
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, bottom: 5, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentGroup,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  currentGroup == 'Information'
                      ? GestureDetector(
                          onTap: () async {
                            controller.isLoading.value = true;
                            LatLng? location = await Get.to(() => MapPage(
                                controller.latitude.value,
                                controller.longitude.value));
                            if (location != null) {
                              // Start loading when the location is selected
                              print(
                                  'check: ====> Lat: ${location.latitude}, Lon: ${location.longitude}');
                              await controller.updateLocation(location);
                            }
                            controller.isLoading.value = false;
                          },
                          child: CircleAvatar(
                              backgroundColor: AppColors().app_primary_bg,
                              child: Icon(Icons.map,
                                  color: AppColors().app_primary)),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...questions.map((q) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildQuestionWidget(q),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (controller.currentStep.value > 0)
                        ElevatedButton(
                          onPressed: controller.prevStep,
                          child: const Text("Previous"),
                        ),
                      if (controller.currentStep.value < groupKeys.length - 1)
                        ElevatedButton(
                          onPressed: () {
                            _validateAndMoveNext(questions);
                            controller.isLocationUpdated.value = false;
                          },
                          child: const Text("Next"),
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            _validateAndSubmit(questions);
                          },
                          child: const Text("Submit"),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Validate fields and move to the next step
  void _validateAndMoveNext(List<SurveyQuestion> questions) {
    controller.isValid.value = true; // Enable validation
    if (_isFormValid(questions)) {
      controller.nextStep();
    }
  }

  // Validate fields and submit form
  void _validateAndSubmit(List<SurveyQuestion> questions) {
    controller.isValid.value = true; // Enable validation
    if (_isFormValid(questions)) {
      // Implement submission logic here
      controller.submitFinal();
      print('Form is valid, submitting...');
    }
  }

  // Check if the form is valid based on required fields
  bool _isFormValid(List<SurveyQuestion> questions) {
    for (var question in questions) {
      if (question.required == '1') {
        if (question.type == 'String' &&
            (question.answer == null || question.answer!.isEmpty || question.answer == 'null')) {
          return false;
        }
        if (question.type == 'Date' &&
            (question.answer == null || question.answer == 'null')) {
          return false;
        }
        if (question.type == 'Time' &&
            (question.answer == null || question.answer == 'null')) {
          return false;
        }
        if (question.type == 'Number' &&
            (question.answer == null || question.answer!.toString().isEmpty)) {
          return false;
        }
        if (question.type == 'Array' &&
            (question.answer == null || question.answer == 'null')) {
          return false;
        }
      }
    }
    return true;
  }

  Widget _buildQuestionWidget(SurveyQuestion question) {
    switch (question.type) {
      case 'String':
        return Obx(() => TextField(
              decoration: InputDecoration(
                labelText: question.title,
                labelStyle: TextStyle(color: AppColors().app_primary),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColors().app_primary),
                ),
                border: OutlineInputBorder(),
                errorText: controller.isValid.value &&
                        question.required == '1' &&
                        (question.answer == null
                            || question.answer == 'null')
                    ? 'This field is required'
                    : null,
              ),
              cursorColor: AppColors().app_primary,
              readOnly: internetController.isNetworkWorking.value
                  ?controller.isReadOnlyFieldOnline(question.title)
                  :controller.isReadOnlyFieldOffline(question.title),
              textInputAction: TextInputAction.next,
              controller: TextEditingController(text: question.answer.toString() == 'null'?'':
    question.answer.toString()),
              onChanged: (val) => question.answer = val,
            ));
      case 'Number':
        return TextField(
          decoration: InputDecoration(
            labelText: question.title,
            labelStyle: TextStyle(color: AppColors().app_primary),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: AppColors().app_primary),
            ),
            border: OutlineInputBorder(),
            errorText: controller.isValid.value &&
                    question.required == '1' &&
                    (question.answer == null
                        || question.answer == 'null')
                ? 'This field is required'
                : null,
          ),
          cursorColor: AppColors().app_primary,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          controller:
              TextEditingController(text: question.answer.toString() == 'null'?'':
                  question.answer.toString()),
          onChanged: (val) => question.answer = int.tryParse(val),
        );
      case 'Date':
        return _datePicker(question);
      case 'Time':
        return _timePicker(question);
      case 'Boolean':
        return SwitchListTile(
          title: Text(question.title),
          activeColor: AppColors().app_primary,
          value: (question.answer == "true")
              ? true
              : (question.answer == "false")
                  ? false
                  : (question.answer is bool)
                      ? question.answer
                      : false,
          onChanged: (val) {
            setState(() {
              question.answer = val;
            });
          },
        );
      case 'Array':
        return _imagePicker(question);
      default:
        return SizedBox();
    }
  }

  Widget _datePicker(SurveyQuestion question) {
    final isInvalid = controller.isValid.value &&
        question.required == '1' &&
        (question.answer == null || question.answer == 'null');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            question.title,
            style: TextStyle(color: AppColors().app_primary),
          ),
          subtitle: Text(
            (question.answer == null || question.answer == 'null')
                ? "Select date"
                : question.answer,
            style: TextStyle(color: AppColors().black_font_color),
          ),
          trailing: Icon(Icons.date_range, color: AppColors().app_primary),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() {
                question.answer = date.toIso8601String().split('T')[0];
              });
            }
          },
        ),
        if (isInvalid)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              'This date is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _timePicker(SurveyQuestion question) {
    final isInvalid = controller.isValid.value &&
        question.required == '1' &&
        (question.answer == null || question.answer == 'null');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            question.title,
            style: TextStyle(color: AppColors().app_primary),
          ),
          subtitle: Text(
            (question.answer == null || question.answer == 'null')
                ? "Select time"
                : question.answer,
            style: TextStyle(color: AppColors().black_font_color),
          ),
          trailing: Icon(Icons.access_time, color: AppColors().app_primary),
          onTap: () async {
            TimeOfDay? time = await showTimePicker(
              context: Get.context!,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                question.answer = time.format(context);
              });
            }
          },
        ),
        if (isInvalid)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              'This time is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _imagePicker(SurveyQuestion question) {
    List<String> images = [];

    // Properly parse answer string to List<String>
    if (question.answer != null && question.answer != 'null') {
      images = (question.answer as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty) // ✅ FIXED
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            question.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors().app_primary,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            ...images.map((path) {
              final file = File(path);
              final exists = file.existsSync();

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors().app_primary_bg,
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: exists
                          ? Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 30),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          images.remove(path);
                          question.answer = images.join(','); // update as string
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black54,
                        ),
                        child: Icon(Icons.close,
                            size: 20, color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            /// Add button
            if (images.length < 3)
              GestureDetector(
                onTap: () async {
                  final XFile? picked =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    Get.snackbar("Uploading", "Saving image locally...",
                        showProgressIndicator: true);

                    final savedPath = await controller.saveImageOffline(File(picked.path));

                    Get.closeAllSnackbars();

                    if (savedPath != null) {
                      setState(() {
                        images.add(savedPath);
                        question.answer = images.join(','); // update as CSV
                      });
                    } else {
                      Get.snackbar("Upload Failed", "Could not save image.",
                          backgroundColor: AppColors().app_alert_extreme,
                          colorText: AppColors().app_secondary);
                    }
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors().app_primary_bg,
                  ),
                  child: Icon(Icons.add_a_photo, color: AppColors().app_primary),
                ),
              ),
          ],
        ),
        if (controller.isValid.value &&
            question.required == '1' &&
            images.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'This field is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

}
