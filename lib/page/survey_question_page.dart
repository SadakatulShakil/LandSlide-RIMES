import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/survey/survey_question_controller.dart';
import '../models/question_model.dart';

class SurveyQuestionPage extends StatelessWidget {
  final controller = Get.put(SurveyController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Survey Question")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final groupKeys = controller.groupedQuestions.keys.toList();

        if (groupKeys.isEmpty) {
          return const Center(child: Text("No survey questions found."));
        }

        final currentGroup = groupKeys[controller.currentStep.value];
        final questions = controller.groupedQuestions[currentGroup]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.green, // Change the color of the stepper
                  ),
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
              padding: const EdgeInsets.only(left: 16.0, bottom: 5),
              child: Text(
                currentGroup,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
        if (question.type == 'String' && (question.answer == null || question.answer!.isEmpty)) {
          return false;
        }
        if (question.type == 'Number' && (question.answer == null || question.answer!.toString().isEmpty)) {
          return false;
        }
        if (question.type == 'Array' && (question.answer == null || (question.answer as List).isEmpty)) {
          return false;
        }
      }
    }
    return true;
  }

  Widget _buildQuestionWidget(SurveyQuestion question) {
    switch (question.type) {
      case 'String':
        return TextField(
          decoration: InputDecoration(
            labelText: question.title,
            border: OutlineInputBorder(),
            errorText: controller.isValid.value && question.required == '1' && (question.answer == null || question.answer!.isEmpty)
                ? 'This field is required'
                : null,
          ),
          controller: TextEditingController(text: question.answer ?? ''),
          onChanged: (val) => question.answer = val,
        );
      case 'Number':
        return TextField(
          decoration: InputDecoration(
            labelText: question.title,
            border: OutlineInputBorder(),
            errorText: controller.isValid.value && question.required == '1' && (question.answer == null || question.answer!.isEmpty)
                ? 'This field is required'
                : null,
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: question.answer?.toString() ?? ''),
          onChanged: (val) => question.answer = int.tryParse(val),
        );
      case 'Date':
        return _datePicker(question);
      case 'Time':
        return _timePicker(question);
      case 'Boolean':
        return SwitchListTile(
          title: Text(question.title),
          value: question.answer ?? false,
          onChanged: (val) => question.answer = val,
        );
      case 'Array':
        return _imagePicker(question);
      default:
        return SizedBox();
    }
  }

  Widget _datePicker(SurveyQuestion question) {
    return ListTile(
      title: Text(question.title),
      subtitle: Text(question.answer ?? "Select date"),
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          question.answer = date.toIso8601String().split('T')[0];
          controller.update();
        }
      },
    );
  }

  Widget _timePicker(SurveyQuestion question) {
    return ListTile(
      title: Text(question.title),
      subtitle: Text(question.answer ?? "Select time"),
      onTap: () async {
        TimeOfDay? time = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          question.answer = time.format(Get.context!);
          controller.update();
        }
      },
    );
  }

  Widget _imagePicker(SurveyQuestion question) {
    // Ensure it's a list if no answer is present yet
    question.answer ??= <String>[];
    List<String> images = List<String>.from(question.answer);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(question.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8,
          children: [
            // Display selected image thumbnails
            ...images.map((path) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(
                    File(path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  GestureDetector(
                    onTap: () {
                      images.remove(path);  // Remove the image on close button tap
                      question.answer = images;
                      controller.update();
                    },
                    child: Container(
                      color: Colors.black54,
                      child: Icon(Icons.close, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              );
            }).toList(),
            // If less than 3 images are selected, show add button
            if (images.length < 3)
              GestureDetector(
                onTap: () async {
                  final List<XFile>? picked = await _picker.pickMultiImage();
                  if (picked != null && picked.isNotEmpty) {
                    for (var x in picked) {
                      if (images.length < 3) {
                        images.add(x.path);  // Add the image path to list
                      }
                    }
                    question.answer = images;
                    controller.update();
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: Icon(Icons.add_a_photo),
                ),
              ),
          ],
        ),
        // Validation message for required field
        if (controller.isValid.value && question.required == '1' && images.isEmpty)
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
