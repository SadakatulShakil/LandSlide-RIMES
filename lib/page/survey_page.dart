import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:lanslide_report/page/survey_question_page.dart';

import '../controller/survey/surveylist_controller.dart';

class SurveyPage extends StatelessWidget {
  final SurveyListController controller = Get.put(SurveyListController());

  void _showDeleteDialog(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Survey !', style: TextStyle(color: Colors.red),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text('Are you sure you want to delete this survey?'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('NO'),
            onPressed: () => Get.back(), // Close dialog, let user pick again
          ),
          TextButton(
            child: const Text('YES'),
            onPressed: () {
              controller.deleteSurvey(id);// Return location
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();

    Get.defaultDialog(
      title: "Create Survey",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
              hintText: 'Enter title',
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                controller.createSurvey(title);
              } else {
                Get.snackbar("Validation", "Title is required",
                    backgroundColor: AppColors().app_alert_severe,
                    colorText: AppColors().app_secondary);
              }
            },
            child: controller.isLoading.value
                ? CircularProgressIndicator()
                : Text("Create"),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchSurveys();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("My Surveys"), backgroundColor: AppColors().app_primary_bg,),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.surveys.isEmpty) {
            return Center(child: Text("No surveys yet."));
          }

          return ListView.builder(
            itemCount: controller.surveys.length,
            itemBuilder: (context, index) {
              final survey = controller.surveys[index];
              return GestureDetector(
                  onTap: () async{
                    if(survey.status == 'complete') {
                      Get.snackbar("Survey Status", "This survey is already completed",
                          backgroundColor: AppColors().app_alert_moderate,
                          colorText: AppColors().app_secondary);
                      return;
                    }
                    var result = await Get.to(() => SurveyQuestionPage(),
                        arguments: {'surveyId': survey.id});
                    if (result == 'refresh') {
                      controller.fetchSurveys();
                    }
                  },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                  child: Container(
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Number Box with Background Color (dynamic size)
                        Container(
                          height: 85,
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: AppColors().app_primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Title and Subtitle
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  survey.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16,),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  survey.status,
                                  style: TextStyle(
                                    color: survey.status == 'complete' ? Colors.green : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Delete Icon
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red.shade100,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _showDeleteDialog(survey.id),
                              tooltip: 'Delete',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateDialog(context),
          backgroundColor: AppColors().app_primary_bg,
          child: Icon(Icons.add, color: AppColors().app_primary),
        ),
      ),
    );
  }
}
