import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/webview/webview_controller.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(()=> Text(controller.title.value)),
      ),
      body: Stack(
          alignment: Alignment.center,
          children: [
            WebViewWidget(controller: controller.webViewController),
            Obx(()=> Visibility(
                visible: controller.isPageLoading.value != 100,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors().app_secondary,
                  color: AppColors().app_primary,
                )
            ))
          ]
      )
    );
  }
}
