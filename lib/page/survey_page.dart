import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:lanslide_report/page/survey_question_page.dart';

import '../controller/survey/surveylist_controller.dart';

class SurveyPage extends StatelessWidget {
  final SurveyListController controller = Get.put(SurveyListController());

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
                      Get.snackbar("Survey Status", "This survey is already completed");
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        // Number Box with Background Color
                        Container(
                          width: 50,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
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
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
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

                        // Delete Icon with Circular Background
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red.shade100,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red, size: 20,),
                              onPressed: () => controller.deleteSurvey(survey.id),
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
                Get.snackbar("Validation", "Title is required");
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
}
