import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utills/AppColors.dart';
import '../controller/flood_forecast/flood_forecast_controller.dart';

class FloodForecastView extends GetView<FloodForecastController> {
  const FloodForecastView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('flood_forecast'.tr),
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
