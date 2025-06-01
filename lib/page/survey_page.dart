import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:lanslide_report/controller/reportList/reportListController.dart';
import 'package:lanslide_report/page/survey_question_page.dart';
import '../controller/survey/surveylist_controller.dart';

class SurveyPage extends StatelessWidget {
  final EventListController controller = Get.put(EventListController());

  void _showDeleteDialog(String id) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_survey'.tr, style: TextStyle(color: Colors.red),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text('delete_survey_msg'.tr),
          ],
        ),
        actions: [
          TextButton(
            child: Text('no'.tr),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('yes'.tr),
            onPressed: () {
              controller.deleteSurvey(id);
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showSyncDialog(String id, String title) {
    final isSyncing = false.obs;
    final resultMessage = ''.obs;

    Get.dialog(
      Obx(() => AlertDialog(
        title: Text('Sync Survey', style: TextStyle(color: Colors.blue)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSyncing.value)
              Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Syncing in progress...'),
                ],
              )
            else if (resultMessage.value.isNotEmpty)
              Text(resultMessage.value)
            else
              Text('Check your internet connection before syncing survey data.'),
          ],
        ),
        actions: [
          if (!isSyncing.value && resultMessage.value.isEmpty)
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Get.back(),
            ),
          if (!isSyncing.value && resultMessage.value.isEmpty)
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                isSyncing.value = true;
                try {
                  await controller.syncSurvey(id, title);
                  resultMessage.value = "✅ Survey synced successfully!";
                  await controller.fetchSurveys();
                } catch (e) {
                  resultMessage.value = "❌ Sync failed: $e";
                } finally {
                  isSyncing.value = false;
                }
              },
            ),
          if (resultMessage.value.isNotEmpty)
            TextButton(
              child: Text('Close'),
              onPressed: () => Get.back(),
            ),
        ],
      )),
      barrierDismissible: false,
    );
  }


  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();

    Get.defaultDialog(
      title: "create_survey".tr,
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'survey_title'.tr,
              hintText: 'enter_title'.tr,
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
                Get.snackbar("validation".tr, "title_required".tr,
                    backgroundColor: AppColors().app_alert_severe,
                    colorText: AppColors().app_secondary);
              }
            },
            child: controller.isLoading.value
                ? CircularProgressIndicator()
                : Text("create_btn".tr),
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
        appBar: AppBar(title: Text("my_survey".tr), backgroundColor: AppColors().app_primary_bg,),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.surveys.isEmpty) {
            return Center(child: Text("no_surveys".tr));
          }

          return ListView.builder(
            itemCount: controller.surveys.length,
            itemBuilder: (context, index) {
              final survey = controller.surveys[index];
              return GestureDetector(
                onTap: () async{
                  if(survey.status == 'complete') {
                    Get.snackbar("survey_status".tr, "survey_status_msg".tr,
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
                        Column(
                          children: [
                            Visibility(
                              visible: survey.status != 'complete',
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.blue.shade100,
                                  child: IconButton(
                                    icon: const Icon(Icons.sync, color: Colors.blueAccent, size: 15),
                                    onPressed: () => _showSyncDialog(survey.id, survey.title),
                                    tooltip: 'Sync',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.red.shade100,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 15),
                                  onPressed: () => _showDeleteDialog(survey.id),
                                  tooltip: 'Delete',
                                ),
                              ),
                            ),
                          ],
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
