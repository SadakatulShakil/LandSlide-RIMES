import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/api_service.dart';

class WeatherAlertController extends GetxController {
  //TODO: Implement WeatherAlertController

  var isPageLoading = 0.obs;
  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(ApiURL.webview_url)).obs;

  @override
  void onInit() {
    super.onInit();
    webViewController?..setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) { isPageLoading.value = 0; print('Progress : ${isPageLoading.value}'); },
      onProgress: (int progress) { isPageLoading.value = progress; print('Progress : ${isPageLoading.value}'); },
      onPageFinished: (url) { isPageLoading.value = 100; print('Progress : ${isPageLoading.value}'); }
    ));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
