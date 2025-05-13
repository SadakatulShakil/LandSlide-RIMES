import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:lanslide_report/page/survey_question_page.dart';

import '../controller/survey/surveylist_controller.dart';

class SurveyPage extends StatelessWidget {
  final SurveyListController controller = Get.put(SurveyListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Card(
                child: ListTile(
                  title: Text(survey.title),
                  subtitle: Text(survey.status, style: TextStyle(
                      color: survey.status == 'complete'
                          ? Colors.green : Colors.blue,
                          fontWeight: FontWeight.bold
                  ) ,),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteSurvey(survey.id),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: Icon(Icons.add),
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
